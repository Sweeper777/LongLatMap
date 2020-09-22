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
            let maxId: Int = realm.objects(Marker.self).max(ofProperty: "id") ?? 0
            marker.id = maxId + 1
            realm.add(marker)
        }
    }
    
    func updateMarker(_ marker: Marker,
                      latitude: Double? = nil,
                      longitude: Double? = nil,
                      rotation: Int? = nil,
                      color: String? = nil,
                      title: String? = nil,
                      desc: String? = nil) throws {
        try realm.write {
            latitude.map { marker.latitude = $0 }
            longitude.map { marker.longitude = $0 }
            rotation.map { marker.rotation = $0 }
            color.map { marker.color = $0 }
            title.map { marker.title = $0 }
            desc.map { marker.desc = $0 }
        }
    }
}
