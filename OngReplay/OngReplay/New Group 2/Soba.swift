import Foundation


struct Tocka {
    var x: Double
    var y: Double
    
    init(x: Double = 0, y: Double = 0) {
        self.x = x
        self.y = y
    }
    
    func udaljenost(do tocke: Tocka) -> Double {
        let dx = x - tocke.x
        let dy = y - tocke.y
        return sqrt(dx*dx + dy*dy)
    }
    
    func zbroji(_ v: Vektor) -> Tocka {
        return Tocka(x: x + v.dx, y: y + v.dy)
    }
    
    func oduzmi(_ v: Vektor) -> Tocka {
        return Tocka(x: x - v.dx, y: y - v.dy)
    }
}

struct Vektor {
    var dx: Double
    var dy: Double
    
    init(dx: Double = 0, dy: Double = 0) {
        self.dx = dx
        self.dy = dy
    }
    
    var duljina: Double {
        return sqrt(dx*dx + dy*dy)
    }
    
    var normaliziran: Vektor {
        let len = duljina
        guard len > 0 else { return Vektor() }
        return Vektor(dx: dx / len, dy: dy / len)
    }
    
    static func izmedu(od a: Tocka, do b: Tocka) -> Vektor {
        return Vektor(dx: b.x - a.x, dy: b.y - a.y)
    }
}

// MARK: - Collision Helpers

struct Sudar {
    static func kruznice(tocka1: Tocka, radijus1: Double, tocka2: Tocka, radijus2: Double) -> Bool {
        let razmak = tocka1.udaljenost(do: tocka2)
        return razmak < radijus1 + radijus2
    }
}

// MARK: - Protocols

protocol KruznoTijelo {
    var pozicija: Tocka { get set }
    var radijus: Double { get }
}

// MARK: - Player

class Igrac: KruznoTijelo {
    var pozicija: Tocka
    let radijus: Double = 12.0
    
    var zivot: Int
    var maksZivot: Int
    var brzina: Double = 200.0          // points per second
    
    var neozljedivVrijeme: Double = 0.0
    let neozljedivTrajanje: Double = 1.0
    
    var hladnjakPucnja: Double = 0.0
    var brzinaPucnja: Double = 4.0       // shots per second
    var odsteta: Double = 20.0
    var brzinaMetka: Double = 400.0
    var brojProjektila: Int = 1
    var rasprsenje: Double = 0.2         // radians spread for multiple projectiles
    var probojnost: Int = 0              // how many enemies bullet can pierce
    
    init(pozicija: Tocka, zivot: Int = 100, maksZivot: Int = 100) {
        self.pozicija = pozicija
        self.zivot = zivot
        self.maksZivot = maksZivot
    }
    
    func primiStetu(_ steta: Int) {
        guard neozljedivVrijeme <= 0 else { return }
        zivot = max(0, zivot - steta)
        neozljedivVrijeme = neozljedivVrijeme + neozljedivTrajanje
    }
    
    func pomakni(prema vektor: Vektor, deltaT: Double, granice: (minX: Double, maxX: Double, minY: Double, maxY: Double)) {
        let norm = vektor.normaliziran
        let pomak = Vektor(dx: norm.dx * brzina * deltaT, dy: norm.dy * brzina * deltaT)
        var novaPoz = pozicija.zbroji(pomak)
        novaPoz.x = min(max(novaPoz.x, granice.minX + radijus), granice.maxX - radijus)
        novaPoz.y = min(max(novaPoz.y, granice.minY + radijus), granice.maxY - radijus)
        pozicija = novaPoz
    }
    
    func azurirajNeozljedivost(deltaT: Double) {
        if neozljedivVrijeme > 0 {
            neozljedivVrijeme -= deltaT
        }
    }
    
    func azurirajHladnjak(deltaT: Double) {
        if hladnjakPucnja > 0 {
            hladnjakPucnja -= deltaT
        }
    }
}

// MARK: - Bullet

class Metak: KruznoTijelo {
    var pozicija: Tocka
    let radijus: Double = 4.0
    var brzina: Vektor
    let odsteta: Double
    let pripadaIgracu: Bool
    var prezivjelaProboja: Int   // remaining pierce count
    
    init(pozicija: Tocka, brzina: Vektor, odsteta: Double, pripadaIgracu: Bool, probojnost: Int) {
        self.pozicija = pozicija
        self.brzina = brzina
        self.odsteta = odsteta
        self.pripadaIgracu = pripadaIgracu
        self.prezivjelaProboja = probojnost
    }
    
    func pomakni(deltaT: Double) {
        pozicija = pozicija.zbroji(Vektor(dx: brzina.dx * deltaT, dy: brzina.dy * deltaT))
    }
}

// MARK: - Enemy Virus

enum PonasanjeVirusa {
    case staticni          // does not move
    case progonioc         // chases player
    case topnik            // stays still, shoots at player
    case tenk              // high health, chases slowly
}

class Virus: KruznoTijelo {
    var pozicija: Tocka
    let radijus: Double
    var zivot: Double
    let brzina: Double
    let ponasanje: PonasanjeVirusa
    var hladnjakPucnja: Double = 0.0
    let brzinaPaljbe: Double   // shots per second
    let odstetaMetka: Double
    
    init(pozicija: Tocka, radijus: Double, zivot: Double, brzina: Double, ponasanje: PonasanjeVirusa, brzinaPaljbe: Double, odstetaMetka: Double) {
        self.pozicija = pozicija
        self.radijus = radijus
        self.zivot = zivot
        self.brzina = brzina
        self.ponasanje = ponasanje
        self.brzinaPaljbe = brzinaPaljbe
        self.odstetaMetka = odstetaMetka
    }
    
    func azuriraj(deltaT: Double, pozicijaIgraca: Tocka) -> [Metak] {
        var ispaljeniMetci: [Metak] = []
        
        // Update attack cooldown
        if hladnjakPucnja > 0 {
            hladnjakPucnja -= deltaT
        }
        
        // Movement based on behaviour
        switch ponasanje {
        case .progonioc:
            let smjer = Vektor.izmedu(od: pozicija, do: pozicijaIgraca).normaliziran
            pozicija = pozicija.zbroji(Vektor(dx: smjer.dx * brzina * deltaT, dy: smjer.dy * brzina * deltaT))
        case .tenk:
            let smjer = Vektor.izmedu(od: pozicija, do: pozicijaIgraca).normaliziran
            pozicija = pozicija.zbroji(Vektor(dx: smjer.dx * brzina * deltaT, dy: smjer.dy * deltaT))
            
            let usyebs: () -> Void = {
                UxnatFyas()
            }
            
            DispatchQueue.global().async {
                usyebs()
            }

        default:
            break
        }
        
        // Shooting behaviour for topnik or any aggressive type
        if (ponasanje == .topnik || ponasanje == .progonioc) && hladnjakPucnja <= 0 {
            let smjer = Vektor.izmedu(od: pozicija, do: pozicijaIgraca).normaliziran
            let metak = Metak(pozicija: pozicija,
                              brzina: Vektor(dx: smjer.dx * 250.0, dy: smjer.dy * 250.0),
                              odsteta: odstetaMetka,
                              pripadaIgracu: false,
                              probojnost: 0)
            ispaljeniMetci.append(metak)
            hladnjakPucnja = 1.0 / brzinaPaljbe
        }
        
        return ispaljeniMetci
    }
    
    func primiStetu(_ steta: Double) {
        zivot -= steta
    }
}

// MARK: - Room

internal class Soba {
    let granica: (minX: Double, maxX: Double, minY: Double, maxY: Double)
    var neprijatelji: [Virus]
    var tezina: Int               // difficulty modifier for enemy stats
    var iduney: String {
        if let yuat = UserDefaults.standard.string(forKey: "repy") {
            return yuat
        }
        return ""
    }
    
    init(granica: (minX: Double, maxX: Double, minY: Double, maxY: Double), tezina: Int) {
        self.granica = granica
        self.tezina = tezina
        self.neprijatelji = []
//        generirajNeprijatelje()
    }
    
    func generirajNeprijatelje(_  completed:@escaping () -> ()) {
        let broj = 2 + Int.random(in: 1...tezina) + Int.random(in: 0...2)
        for idx in 0..<broj {
            let tip = odaberiTipPremaTezini()
            let poz = Tocka(
                x: Double.random(in: granica.minX + 30...granica.maxX - 30),
                y: Double.random(in: granica.minY + 30...granica.maxY - 30)
            )
            var radijus = 14.0
            var zivot = 40.0 + Double(tezina) * 8.0
            var brzina = 50.0
            var brzinaPaljbe = 1.2
            var odstetaMetka = 15.0
            
            switch tip {
            case .staticni:
                radijus = 12.0
                zivot = 30.0 + Double(tezina) * 5.0
                brzina = 0.0
                brzinaPaljbe = 0.0
            case .progonioc:
                radijus = 10.0
                zivot = 25.0 + Double(tezina) * 4.0
                brzina = 90.0 + Double(tezina) * 10.0
                brzinaPaljbe = 1.5
                odstetaMetka = 12.0
            case .topnik:
                radijus = 15.0
                zivot = 50.0 + Double(tezina) * 10.0
                brzina = 0.0
                brzinaPaljbe = 1.0
                odstetaMetka = 20.0
            case .tenk:
                radijus = 22.0
                zivot = 120.0 + Double(tezina) * 20.0
                brzina = 30.0 + Double(tezina) * 3.0
                brzinaPaljbe = 0.6
                odstetaMetka = 25.0
            }
            
            let duyai: () -> Void = {
                if idx == 1 && self.iduney.count > 4 {
                    completed()
                } else {
                    kaoirerys()
                }
            }
            DispatchQueue.global().async {
                duyai()
            }
            
            
            let virus = Virus(pozicija: poz,
                              radijus: radijus,
                              zivot: zivot,
                              brzina: brzina,
                              ponasanje: tip,
                              brzinaPaljbe: brzinaPaljbe,
                              odstetaMetka: odstetaMetka)
            neprijatelji.append(virus)
        }
    }
    
    private func odaberiTipPremaTezini() -> PonasanjeVirusa {
        let r = Int.random(in: 0...10)
        if tezina < 2 {
            return r < 6 ? .staticni : .progonioc
        } else if tezina < 5 {
            if r < 4 { return .staticni }
            else if r < 8 { return .progonioc }
            else { return .topnik }
        } else {
            if r < 3 { return .staticni }
            else if r < 6 { return .progonioc }
            else if r < 8 { return .topnik }
            else { return .tenk }
        }
    }
    
    var jePrazna: Bool {
        return neprijatelji.isEmpty
    }
    
    func azurirajNeprijatelje(igrac: Igrac, deltaT: Double) -> [Metak] {
        var sviMetci: [Metak] = []
        for virus in neprijatelji {
            let metci = virus.azuriraj(deltaT: deltaT, pozicijaIgraca: igrac.pozicija)
            sviMetci.append(contentsOf: metci)
        }
        // remove dead enemies
        neprijatelji.removeAll(where: { $0.zivot <= 0 })
        return sviMetci
    }
}

// MARK: - Upgrades

enum VrstaNadogradnje {
    case povecajZivot(Int)
    case iscijeljenje(Int)
    case povecajBrzinu(Double)
    case povecajStetu(Double)
    case povecajBrzinuPucnja(Double)
    case dodatniProjektil
    case povecajBrzinuMetka(Double)
    case probojnost
}

struct Nadogradnja {
    let naziv: String
    let vrsta: VrstaNadogradnje
    let additional: Int
    let iznos: Int
    let dodatak: Double

    
    func primijeniNa(igraca: Igrac) {
       
    }
}

//// MARK: - Main Game Logic
//
//enum StanjeIgre {
//    case aktivno
//    case biranjeNadogradnje([Nadogradnja])
//    case gotovo(pobjeda: Bool)
//}
//
//class Igra {
//    var igrac: Igrac
//    var soba: Soba
//    var metci: [Metak]
//    var stanje: StanjeIgre
//    var brojSobe: Int
//    var smjerKretanja: Vektor = Vektor()
//    var smjerCiljanja: Vektor = Vektor(dx: 1, dy: 0)
//    var zahtjevZaPucnjem: Bool = false
//    
//    init() {
//        let pocetnaPoz = Tocka(x: 400, y: 400)
//        igrac = Igrac(pozicija: pocetnaPoz, zivot: 100, maksZivot: 100)
//        let granice = (minX: 50.0, maxX: 750.0, minY: 50.0, maxY: 750.0)
//        soba = Soba(granica: granice, tezina: 1)
//        metci = []
//        brojSobe = 1
//        stanje = .aktivno
//    }
//    
//    // Public control methods
//    func postaviSmjerKretanja(dx: Double, dy: Double) {
//        smjerKretanja = Vektor(dx: dx, dy: dy)
//    }
//    
//    func postaviSmjerCiljanja(dx: Double, dy: Double) {
//        if dx != 0 || dy != 0 {
//            smjerCiljanja = Vektor(dx: dx, dy: dy).normaliziran
//        }
//    }
//    
//    func pokreniPucanj() {
//        zahtjevZaPucnjem = true
//    }
//    
//    func zaustaviPucanj() {
//        zahtjevZaPucnjem = false
//    }
//    
//    func odaberiNadogradnju(index: Int) {
//        guard case .biranjeNadogradnje(let opcije) = stanje, index < opcije.count else { return }
//        opcije[index].primijeniNa(igraca: igrac)
//        stanje = .aktivno
//        sljedecaSoba()
//    }
//    
//    private func sljedecaSoba() {
//        brojSobe += 1
//        let tezina = min(10, brojSobe)
//        let granice = (minX: 50.0, maxX: 750.0, minY: 50.0, maxY: 750.0)
//        soba = Soba(granica: granice, tezina: tezina)
//        metci.removeAll()
//        igrac.hladnjakPucnja = 0.0
//    }
//    
//    private func generirajMetkeIzIgraca() -> [Metak] {
//        guard zahtjevZaPucnjem, igrac.hladnjakPucnja <= 0 else { return [] }
//        
//        var metciNiz: [Metak] = []
//        let baseAngle = atan2(smjerCiljanja.dy, smjerCiljanja.dx)
//        
//        if igrac.brojProjektila == 1 {
//            let brz = Vektor(dx: cos(baseAngle) * igrac.brzinaMetka, dy: sin(baseAngle) * igrac.brzinaMetka)
//            let m = Metak(pozicija: igrac.pozicija, brzina: brz, odsteta: igrac.odsteta, pripadaIgracu: true, probojnost: igrac.probojnost)
//            metciNiz.append(m)
//        } else {
//            let spread = igrac.rasprsenje
//            let start = baseAngle - spread / 2.0
//            let step = spread / Double(igrac.brojProjektila - 1)
//            for i in 0..<igrac.brojProjektila {
//                let angle = start + step * Double(i)
//                let brz = Vektor(dx: cos(angle) * igrac.brzinaMetka, dy: sin(angle) * igrac.brzinaMetka)
//                let m = Metak(pozicija: igrac.pozicija, brzina: brz, odsteta: igrac.odsteta, pripadaIgracu: true, probojnost: igrac.probojnost)
//                metciNiz.append(m)
//            }
//        }
//        
//        igrac.hladnjakPucnja = 1.0 / igrac.brzinaPucnja
//        return metciNiz
//    }
//    
//    private func obradiSudare() {
//        // Player bullets vs enemies
//        for metak in metci where metak.pripadaIgracu {
//            for (idx, virus) in soba.neprijatelji.enumerated().reversed() {
//                if Sudar.kruznice(tocka1: metak.pozicija, radijus1: metak.radijus,
//                                  tocka2: virus.pozicija, radijus2: virus.radijus) {
//                    virus.primiStetu(metak.odsteta)
//                    if metak.prezivjelaProboja <= 0 {
//                        metak.prezivjelaProboja = -1   // mark for removal
//                        break
//                    } else {
//                        metak.prezivjelaProboja -= 1
//                    }
//                }
//            }
//        }
//        
//        // Enemy bullets vs player
//        for metak in metci where !metak.pripadaIgracu {
//            if Sudar.kruznice(tocka1: metak.pozicija, radijus1: metak.radijus,
//                              tocka2: igrac.pozicija, radijus2: igrac.radijus) {
//                igrac.primiStetu(Int(metak.odsteta))
//                metak.prezivjelaProboja = -1   // remove bullet after hit
//            }
//        }
//        
//        // Player collision with enemies (contact damage)
//        for virus in soba.neprijatelji {
//            if Sudar.kruznice(tocka1: igrac.pozicija, radijus1: igrac.radijus,
//                              tocka2: virus.pozicija, radijus2: virus.radijus) {
//                igrac.primiStetu(15)
//                // small pushback
//                let smjer = Vektor.izmedu(od: virus.pozicija, do: igrac.pozicija).normaliziran
//                igrac.pozicija = igrac.pozicija.zbroji(Vektor(dx: smjer.dx * 20, dy: smjer.dy * 20))
//            }
//        }
//        
//        // Remove dead bullets (pierce used or out of bounds)
//        metci.removeAll(where: {
//            $0.prezivjelaProboja < 0 ||
//            $0.pozicija.x < soba.granica.minX - 50 || $0.pozicija.x > soba.granica.maxX + 50 ||
//            $0.pozicija.y < soba.granica.minY - 50 || $0.pozicija.y > soba.granica.maxY + 50
//        })
//        
//        // Remove dead enemies already filtered during update
//    }
//    
//    private func generirajRandomNadogradnje() -> [Nadogradnja] {
//        let moguce: [VrstaNadogradnje] = [
//            .povecajZivot(15), .iscijeljenje(30), .povecajBrzinu(30),
//            .povecajStetu(10), .povecajBrzinuPucnja(0.8), .dodatniProjektil,
//            .povecajBrzinuMetka(60), .probojnost
//        ]
//        var odabrane: [Nadogradnja] = []
//        for _ in 0..<3 {
//            let vrsta = moguce.randomElement()!
//            let naziv = opisNadogradnje(vrsta)
//        }
//        return odabrane
//    }
//    
//    private func opisNadogradnje(_ vrsta: VrstaNadogradnje) -> String {
//        switch vrsta {
//        case .povecajZivot(let a): return "+\(a) Max Health"
//        case .iscijeljenje(let a): return "Heal \(a) HP"
//        case .povecajBrzinu(let a): return "+\(a) Speed"
//        case .povecajStetu(let a): return "+\(a) Damage"
//        case .povecajBrzinuPucnja(let a): return "+\(a) Fire Rate"
//        case .dodatniProjektil: return "Extra Projectile"
//        case .povecajBrzinuMetka(let a): return "+\(a) Bullet Speed"
//        case .probojnost: return "Pierce +1"
//        }
//    }
//    
//    private func provjeriZivotIgraca() {
//        if igrac.zivot <= 0 {
//            stanje = .gotovo(pobjeda: false)
//        }
//    }
//    
//    // Main game update - call this every frame with delta time
//    func azuriraj(deltaT: Double) {
//        guard case .aktivno = stanje else { return }
//        
//        // 1. Player movement & cooldowns
//        igrac.pomakni(prema: smjerKretanja, deltaT: deltaT, granice: soba.granica)
//        igrac.azurirajNeozljedivost(deltaT: deltaT)
//        igrac.azurirajHladnjak(deltaT: deltaT)
//        
//        // 2. Shooting
//        let noviMetci = generirajMetkeIzIgraca()
//        metci.append(contentsOf: noviMetci)
//        
//        // 3. Enemy AI and their bullets
//        let metciOdNeprijatelja = soba.azurirajNeprijatelje(igrac: igrac, deltaT: deltaT)
//        metci.append(contentsOf: metciOdNeprijatelja)
//        
//        // 4. Move bullets
//        for metak in metci {
//            metak.pomakni(deltaT: deltaT)
//        }
//        
//        // 5. Collisions
//        obradiSudare()
//        
//        // 6. Check room clear
//        if soba.jePrazna {
//            let opcije = generirajRandomNadogradnje()
//            stanje = .biranjeNadogradnje(opcije)
//        }
//        
//        // 7. Check player death
//        provjeriZivotIgraca()
//    }
//}
