import RealmSwift

class DataManager {
    let markers: Results<Marker>
    private let realm: Realm!

    private init() {
        do {
            realm = try Realm()
            markers = realm.objects(Marker.self)
        } catch let error {
            print(error)
            fatalError()
        }
    }

    private static var _shared: DataManager?

    static var shared: DataManager {
        _shared = _shared ?? DataManager()
        return _shared!
    }
    
    func addMarker(_ marker: Marker) throws {
        try realm.write {
            realm.add(marker)
        }
    }
}
