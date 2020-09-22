//
//  CoreDataController.swift
//  Royal-Botanic-Gardens-Exhibitors-Aid
//
//  Created by Farhad Ullah Rezwan on 2/9/20.
//  Copyright © 2020 Farhad Ullah Rezwan. All rights reserved.
//

import UIKit
import CoreData

class CoreDataController: NSObject, NSFetchedResultsControllerDelegate, DatabaseProtocol {
   
    

    
    var DEFAULT_EXHIBITION_NAME = "Default Exhibition"
    var listeners = MulticastDelegate<DatabaseListener>()
    var persistentContainer: NSPersistentContainer
    
    var allPlantsFetchResultsController: NSFetchedResultsController<Plant>?
    var exhibitionPlantsFetchedResultsController: NSFetchedResultsController<Plant>?
    var allExhibitionsFetchResultsContrller: NSFetchedResultsController<Exhibition>?
    
    override init() {
        persistentContainer = NSPersistentContainer(name: "Royal-Botanic-Exhibitor")
        print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last! as String)
        persistentContainer.loadPersistentStores { (description, error) in
            if let error = error {
                fatalError("Failed to load Core data stack: \(error)")
            }
        }
        
        super.init()

        if fetchAllExhibitions().count == 0 {
            createDefaultEntries2()
        }
        
        
    }
    
    // MARK: - Lazy Initialization of Default team
    lazy var defaultExhibition: [Exhibition] = {
        var exhibitions = [Exhibition] ()
        
        let request: NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
        let predicate = NSPredicate(format: "name = %@", DEFAULT_EXHIBITION_NAME)
        request.predicate = predicate
        
        do {
            try exhibitions = persistentContainer.viewContext.fetch(request)
        } catch {
            print("Fetch Request Failed: \(error)")
        }
        

        return exhibitions
        
    }()
    
    func saveContext() {
        if persistentContainer.viewContext.hasChanges {
            do {
                try persistentContainer.viewContext.save()
            } catch {
                fatalError("Failed to save to CoreData: \(error)")
            }
        }
    }
    
    // MARK: - Database Protocol Functions
    
    func cleanup() {
        saveContext()
    }
    
    func addPlant(name: String, family: String, imageOfPlant: String, scientificName: String, yearDiscovered: Int64) -> Plant {
        let plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: persistentContainer.viewContext) as! Plant
        
        plant.name = name
        plant.family = family
        plant.imageOfPlant = imageOfPlant
        plant.scientificName = scientificName
        plant.yearDiscovered = yearDiscovered

        return plant
    }
    
    func editPlant(oldPlant: Plant, name: String, family: String, scientificName: String, yearDiscovered: Int64) {
        oldPlant.yearDiscovered = yearDiscovered
        oldPlant.family = family
        oldPlant.scientificName = scientificName
        oldPlant.name = name
        
        saveContext()

        
    }
    
    func addPlantFromAPI(plantData: PlantData) -> Plant {
        let plant = NSEntityDescription.insertNewObject(forEntityName: "Plant", into: persistentContainer.viewContext) as! Plant
        
        plant.name = plantData.name
        plant.family = plantData.family
        plant.scientificName = plantData.scientificName
        plant.imageOfPlant = plantData.imageOfPlant
        // need work
        plant.yearDiscovered = plantData.yearDiscovered ?? 0
        

        return plant
    }
    
    func addExhibition(name: String, desc: String, exhibitionLat: Double, exhibitionLon: Double, icon: String) -> (Exhibition, Bool) {
        let exhibition = NSEntityDescription.insertNewObject(forEntityName: "Exhibition", into: persistentContainer.viewContext) as! Exhibition
        
        exhibition.name = name
        exhibition.desc = desc
        exhibition.exhibitionLat = exhibitionLat
        exhibition.exhibitionLon = exhibitionLon
        exhibition.icon = icon
        
        // check 3 plants are added or not
        if exhibition.plants?.count == 3 {
            
        }

        return (exhibition, true)
        
    }
    
    func addPlantToExhibit(plant: Plant, exhibition: Exhibition) -> plantsAddableOrNot {

        guard let plantContain = exhibition.plants, plantContain.contains(plant) == false else {
            return .alreadyContainsSamePlant
        }

        guard let plantHas = exhibition.plants, plantHas.count < 3 else {
            return .lessThanThree
        }
//        print("Hoyse")
        exhibition.addToPlants(plant)
        return.addable
    }

    func deletePlant(plant: Plant) {
        persistentContainer.viewContext.delete(plant)
    }
    
    func deleteExhibition(exhibition: Exhibition) {
        persistentContainer.viewContext.delete(exhibition)
    }
    
    func removePlantFromExhibition(plant: Plant, exhibition: Exhibition) {
        exhibition.removeFromPlants(plant)
    }
    
    func addListener(listener: DatabaseListener) {
        listeners.addDelegate(listener)
        
        if listener.listenerType == .exhibitionPlants || listener.listenerType == .all {
            listener.onExhibitionPlantsChange(change: .update, exhibitionPlants: fetchFromExhibitPlants())
        }
        
        if listener.listenerType == .plants || listener.listenerType == .all {
            listener.onPlantListChange(change: .update, plants: fetchAllPlants())
        }
        
        if listener.listenerType == .exhibition || listener.listenerType == .all {
            listener.onExhibitionChange(change: .update, exhibitions: fetchAllExhibitions())
        }
        
    }
    
    func removeListener(listener: DatabaseListener) {
        saveContext()
        listeners.removeDelegate(listener)
        
    }
    
    /// Sets default exhibit to be shown in the exhibition detals page.
    /// Helps to get the values of exhibitions table view data
    /// - Parameter name: name of the exhibition
    func setDefaultExhibit(name: String) {
        DEFAULT_EXHIBITION_NAME = name
    }

    // MARK: - Fetched Results Controller Protocol Functions
    
    func controllerDidChangeContent(_ controller: NSFetchedResultsController<NSFetchRequestResult>) {
        
        if controller == allPlantsFetchResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .plants || listener.listenerType == .all {
                    listener.onPlantListChange(change: .update, plants: fetchAllPlants())
                }
            }
        } else if controller == exhibitionPlantsFetchedResultsController {
            listeners.invoke { (listener) in
                if listener.listenerType == .exhibitionPlants  || listener.listenerType == .all {
                    listener.onExhibitionPlantsChange(change: .update, exhibitionPlants: fetchFromExhibitPlants())
                }
            }
        }
    }
    
    // MARK: - Core Data Fetch Requests
    
    func fetchAllExhibitions() -> [Exhibition] {
        
        if allExhibitionsFetchResultsContrller == nil {
            let fetchRequest: NSFetchRequest<Exhibition> = Exhibition.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            allExhibitionsFetchResultsContrller = NSFetchedResultsController<Exhibition>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allExhibitionsFetchResultsContrller?.delegate = self
            
            do {
                try allExhibitionsFetchResultsContrller?.performFetch()
            } catch {
                print("Fetch Requst Failed: \(error)")
            }
        }
        
        var exhibitions = [Exhibition]()
        
        if allExhibitionsFetchResultsContrller?.fetchedObjects != nil {
            exhibitions = (allExhibitionsFetchResultsContrller?.fetchedObjects)!
        }
        return exhibitions
    }
    
    /// Fetches all plants
    /// - Returns: returns list of plants
    func fetchAllPlants() -> [Plant] {
        
        if allPlantsFetchResultsController == nil {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            
            allPlantsFetchResultsController = NSFetchedResultsController<Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            allPlantsFetchResultsController?.delegate = self

            do {
                try allPlantsFetchResultsController?.performFetch()
            } catch {
                print("Fetch Requst Failed: \(error)")
            }
        }
        
        var plants = [Plant]()
        
        if allPlantsFetchResultsController?.fetchedObjects != nil {
            plants = (allPlantsFetchResultsController?.fetchedObjects)!
        }
        return plants
    }
    
    func fetchFromExhibitPlants() -> [Plant] {
        if exhibitionPlantsFetchedResultsController == nil {
            let fetchRequest: NSFetchRequest<Plant> = Plant.fetchRequest()
            
            let nameSortDescriptor = NSSortDescriptor(key: "name", ascending: true)
            let predicate = NSPredicate(format: "ANY exhibitions.name == %@", DEFAULT_EXHIBITION_NAME)
            fetchRequest.sortDescriptors = [nameSortDescriptor]
            fetchRequest.predicate = predicate
            
            exhibitionPlantsFetchedResultsController = NSFetchedResultsController<Plant>(fetchRequest: fetchRequest, managedObjectContext: persistentContainer.viewContext, sectionNameKeyPath: nil, cacheName: nil)
            
            exhibitionPlantsFetchedResultsController?.delegate = self
            
            do {
                try exhibitionPlantsFetchedResultsController?.performFetch()
            } catch {
                print("Fetch Requst Failed: \(error)")
            }
        }
        
        var plants = [Plant]()
        
        if exhibitionPlantsFetchedResultsController?.fetchedObjects != nil {
            plants = (exhibitionPlantsFetchedResultsController?.fetchedObjects)!
        }
        return plants
    }
    

    /// Function to populate default entries
    func createDefaultEntries2() {
        
        //  MARK: - Exhibition 1
        let ex1 = addExhibition(name: "Oak Collection", desc: "The great trees of Melbourne Gardens are spectacular throughout the year, but autumn is a particularly special time when the elms, oaks, and many other deciduous trees explode into a mass of vibrant yellow, red and orange.", exhibitionLat: -37.831073, exhibitionLon: 144.977978, icon: "spearmint").0
        
        let p1 = addPlant(name: "Algerian oak", family: "Fagaceae", imageOfPlant: "https://bs.floristic.org/image/o/0718714bdba14b284dbf10f05e249bb7489b8467", scientificName: "Quercus canariensis", yearDiscovered: 1809)
        let p2 = addPlant(name: "northern pin oak", family: "Fagaceae", imageOfPlant: "http://d2seqvvyy3b8p2.cloudfront.net/b81fce6a0929c1731b2601611fc48d71.jpg", scientificName: "Quercus ellipsoidalis", yearDiscovered: 1899)
        let p3 = addPlant(name: "English oak", family: "Fagaceae", imageOfPlant: "https://bs.floristic.org/image/o/2292b670683abdaac354389514105df0018d9ef8", scientificName: "Quercus robur", yearDiscovered: 1753)
        let _ = addPlantToExhibit(plant: p1, exhibition: ex1)
        let _ = addPlantToExhibit(plant: p2, exhibition: ex1)
        let _ = addPlantToExhibit(plant: p3, exhibition: ex1)
        
        //  MARK: - Exhibition 2
        let ex2 = addExhibition(name: "Herb Garden", desc: "A wide range of herbs from well known leafy annuals such as Basil and Coriander, to majestic mature trees such as the Camphor Laurels Cinnamomum camphora and Cassia Bark Tree Cinnamomum burmannii. The large trees are remnants from the original 1890s Medicinal Garden. Plants displayed are from all over the world including Australia, and several are rare or have been collected from the wild.The Herb Garden has many plants with highly fragrant flowers or leaves, which make it a sweetly scented place to visit at any time of the year. The collection and its produce are used by the Gardens education programs.", exhibitionLat: -37.831523, exhibitionLon: 144.979362, icon: "herbs").0
        
        //2
        let p4 = addPlant(name: "broadleaved lavender", family: "Lamiaceae", imageOfPlant: "https://bs.floristic.org/image/o/e0bff466321605b8d3c67b6507c4211ad8a2f4c1", scientificName: "Lavandula latifolia", yearDiscovered: 1784)
        let p5 = addPlant(name: "Rosemary", family: "Lamiaceae", imageOfPlant: "https://bs.floristic.org/image/o/4ac23eba5a0d5bb7c73e3ad8331614c7079dcfe0", scientificName: "Salvia rosmarinus", yearDiscovered: 1835)
        let p6 = addPlant(name: "oregano", family: "Lamiaceae", imageOfPlant: "https://bs.floristic.org/image/o/3ba5f26c99945c13e49d5107a7565f8c6037b7fb", scientificName: "Origanum vulgare", yearDiscovered: 1753)
        
        let _ = addPlantToExhibit(plant: p4, exhibition: ex2)
        let _ = addPlantToExhibit(plant: p5, exhibition: ex2)
        let _ = addPlantToExhibit(plant: p6, exhibition: ex2)
        
        //  MARK: - Exhibition 3
        let ex3 = addExhibition(name: "Camellia Collection", desc: "We have 950 different Camellias in our collection, made up of species and cultivars, and the best place to satisfy your Camellia craving is by going straight to the Camellia Bed!  This large bed contains a beautiful range of Camellias of all shapes and sizes. Many are old Australian, Asian and European cultivars and some of the plants date back to 1875. In 1996, Melbourne Gardens' collection of Camellias was named the Australian National Reference Collection by the Australian Camellia Research Society. Royal Botanic Gardens Victoria at Melbourne Gardens aims to demonstrate the diversity of species within the genus Camellia and provide reference material for research", exhibitionLat:  -37.831249, exhibitionLon: 144.978864, icon: "lily").0
        
        //3
        let p7 = addPlant(name: "camellia", family: "Theaceae", imageOfPlant: "https://bs.floristic.org/image/o/d581db1f72706fdf81c8e34a239f478077ea8cb4", scientificName: "Camellia japonica", yearDiscovered: 1753)
        let p8 = addPlant(name: "Tea-oil-plant", family: "Theaceae", imageOfPlant: "https://bs.floristic.org/image/o/d706dd156d80626b4d40de3b730d8f1193caca90", scientificName: "Camellia oleifera", yearDiscovered: 1818)
        let p9 = addPlant(name: "camellia-grijsii", family: "Theaceae", imageOfPlant: "",  scientificName: "Camellia grijsii", yearDiscovered: 1879)

        let _ = addPlantToExhibit(plant: p7, exhibition: ex3)
        let _ = addPlantToExhibit(plant: p8, exhibition: ex3)
        let _ = addPlantToExhibit(plant: p9, exhibition: ex3)

        //  MARK: - Exhibition 4
        let ex4 = addExhibition(name: "Southern Africa Collection", desc: "The Southern African Collection contains a sample of a variety of plant types including: bulbs, succulents, Cycads, large and small shrubs and herbaceous plants many of which are readily available in the nursery industry and ideal for use in the average home garden Southern Africa’s climate is not dissimilar to ours which makes the cultivation of their flora satisfying in Melbourne’s climate. With its seven climatic regions, Forest, Fyntos, Grasslands, Nana Karoo, Savanna, Succulent Karoo, Thicket and Desert it has a broad range of plants that are both adaptable and water wise.", exhibitionLat: -37.831004, exhibitionLon: 144.978660, icon: "trees").0
        
        //4
        let p10 = addPlant(name: "Mexican blood-flower", family: "Bignoniaceae", imageOfPlant: "https://bs.floristic.org/image/o/dcf3337eaaebd429dfb0fcb3af83219535599f1d", scientificName: "Amphilophium buccinatorium", yearDiscovered: 2014)
        let p11 = addPlant(name: "Japanese pieris", family: "Ericaceae", imageOfPlant: "https://bs.floristic.org/image/o/83187346d9d3e79785e5977a8ebc0858a27ae622", scientificName: "Pieris japonica", yearDiscovered: 1834)
        let p12 = addPlant(name: "pig's ear", family: "crassulaceae", imageOfPlant: "http://d2seqvvyy3b8p2.cloudfront.net/4a21b3728c66079d5df9868005b66fc3.jpg", scientificName: "kalanchoe alternans", yearDiscovered: 1805)
        
        let _ = addPlantToExhibit(plant: p10, exhibition: ex4)
        let _ = addPlantToExhibit(plant: p11, exhibition: ex4)
        let _ = addPlantToExhibit(plant: p12, exhibition: ex4)
        
        //  MARK: - Exhibition 5
        let ex5 = addExhibition(name: "Bamboo Collection", desc: "Melbourne Gardens exhibits a broad range of Bamboo from different regions of the world across the entire site and maintains a consolidated collection within the Bamboo Collection beds. A key objective of the Bamboo collection is to highlight the significant ethnobotanical uses of bamboo and grasses and the vital role they contribute to for life on earth and highlights the threats to grass biodiversity and biomes they support.", exhibitionLat: -37.830789, exhibitionLon: 144.978949, icon: "bamboo").0
        
        //5
        let p13 = addPlant(name: "sacred bamboo", family: "Berberidaceae", imageOfPlant: "https://bs.floristic.org/image/o/c9ee505a8e9c3ff960972c9753e6b2b10f10e0f3", scientificName: "Nandina domestica", yearDiscovered: 1781)
        let p14 = addPlant(name: "broadleaf bamboo", family: "Poaceae", imageOfPlant: "https://bs.floristic.org/image/o/c59492dc6b361aaa0bd5fac0945702f0ed78eb50", scientificName: "Sasa palmata", yearDiscovered: 1913)
        let p15 = addPlant(name: "Castillon bamboo", family: "Poaceae", imageOfPlant: "https://bs.floristic.org/image/o/0dc03f60b8ebf21c0105f234b8b692ee2b5f039e", scientificName: "Phyllostachys reticulata", yearDiscovered: 1873)
        
        let _ = addPlantToExhibit(plant: p13, exhibition: ex5)
        let _ = addPlantToExhibit(plant: p14, exhibition: ex5)
        let _ = addPlantToExhibit(plant: p15, exhibition: ex5)
        
        //  MARK: - Exhibition 6
        let ex6 = addExhibition(name: "Perennial Border", desc: "Using combinations of plants in large drifts, the Perennial Border has been designed for a bold contemporary display. Flowering throughout spring and summer, the display then mellows in autumn as the seed heads darken and the grasses fade.", exhibitionLat:  -37.830517, exhibitionLon: 144.978198, icon: "lily").0
        
        //6
        let p16 = addPlant(name: "Pineapple Lily", family: "Asparagaceae", imageOfPlant: "https://bs.floristic.org/image/o/7c59e278c3ffa6c936e290cd964e6fc3ee0eb3dd", scientificName: "Eucomis comosa", yearDiscovered: 1929)
        let p17 = addPlant(name: "pinnate dahlia", family: "Asteraceae", imageOfPlant: "https://bs.floristic.org/image/o/7668dac94198437027251b196dd98f344184e9d9", scientificName: "Dahlia pinnata", yearDiscovered: 1791)
        let p18 = addPlant(name: "bejuco de agua", family: "Dilleniaceae", imageOfPlant: "https://bs.floristic.org/image/o/0cc00e3fa6eedc97179f391bf691470a7aceeb97", scientificName: "Pinzona coriacea", yearDiscovered: 0)
        
        let _ = addPlantToExhibit(plant: p16, exhibition: ex6)
        let _ = addPlantToExhibit(plant: p17, exhibition: ex6)
        let _ = addPlantToExhibit(plant: p18, exhibition: ex6)


        //  MARK: - Exhibition 7
        let ex7 = addExhibition(name: "Fern Gully", desc: "The Fern Gully is a natural gully within the gardens providing a perfect micro climate for ferns. Visitors can follow a stream via the winding paths in the cool surrounds under the canopy of lush tree ferns. In designing the Fern Gully, William Guilfoyle sought to recreate the fern gullies of the Australian bush. Fossil evidence shows that the soft tree fern dates back to when Australia was part of the super continent Gondwana. Ferns are one of the first plants to re-generate after hot wild fires that kill many other plants. Over the last ten years Fern Gully has suffered from pressures of drought, 30,000 roosting flying foxes, and failing infrastructure. As a result a Fern Gully restoration project is now in place that aims to reverse this trend through a total management approach that considers issues of public amenity, accessibility, tree health, and water quality, over a Three Stage process.", exhibitionLat:  -37.831455, exhibitionLon: 144.980478, icon: "forest").0
        
        //7
        let p19 = addPlant(name: "Cooper's cyathea", family: "Cyatheaceae", imageOfPlant: "https://bs.floristic.org/image/o/efc106f606124839220034a1c2aa5f231f6550aa", scientificName: "Sphaeropteris cooperi", yearDiscovered: 1970)
        let p20 = addPlant(name: "", family: "Cyatheaceae", imageOfPlant: "http://d2seqvvyy3b8p2.cloudfront.net/7f7c95554d2cfd889642f185a6a6d19c.jpg", scientificName: "Cyathea dealbata", yearDiscovered: 1801)
        let p21 = addPlant(name: "Asplenium ladyfern", family: "Aspleniaceae", imageOfPlant: "https://bs.floristic.org/image/o/081e49b548661f596e399a5744a04b03a6581912", scientificName: "Athyrium filix", yearDiscovered: 0)
        
        let _ = addPlantToExhibit(plant: p19, exhibition: ex7)
        let _ = addPlantToExhibit(plant: p20, exhibition: ex7)
        let _ = addPlantToExhibit(plant: p21, exhibition: ex7)

        //  MARK: - Exhibition 8
        let ex8 = addExhibition(name: "Palms", desc: "Around 40 different species of palms are grown here at the Gardens. They are mainly from cooler temperate areas, but there are some surprising exceptions. Jubaea chilensis,Butia capitata and Washingtonia filifera are all considered threatened in their natural habitat. However, here individually they have found a home. The age of the Royal Botanic Gardens Melbourne combined with a relatively mild climate have allowed some specimens to grow to an enormous size.", exhibitionLat: -37.831345, exhibitionLon: 144.980875, icon: "palm").0
        
        // 8
        let p22 = addPlant(name: "Senegal date palm", family: "Arecaceae", imageOfPlant: "https://bs.floristic.org/image/o/f0eea4f4e7b7faecd8a0069c592981393e274e88", scientificName: "Phoenix reclinata", yearDiscovered: 1858)
        let p23 = addPlant(name: "Picabeen palm", family: "Arecaceae", imageOfPlant: "https://bs.floristic.org/image/o/519ba5393b372c3ccc72a40302c455715ebde750", scientificName: "Archontophoenix cunninghamiana", yearDiscovered: 1875)
        let p24 = addPlant(name: "Australian cabbage palm", family: "Arecaceae", imageOfPlant: "https://bs.floristic.org/image/o/f76f421b9cc49b371d3a6a1d14192a7eaec01aa5", scientificName: "Livistona australis", yearDiscovered: 1838)
        
        let _ = addPlantToExhibit(plant: p22, exhibition: ex8)
        let _ = addPlantToExhibit(plant: p23, exhibition: ex8)
        let _ = addPlantToExhibit(plant: p24, exhibition: ex8)

        //  MARK: - Exhibition 9
        let ex9 = addExhibition(name: "Species Rose Collection", desc: "With more than 100 different species and varieties of roses the collection at Melbourne Gardens always has something to offer. Come in spring to see species roses from the northern hemisphere and cultivars bred both here in Australia and overseas in flower. In autumn delight in the changing colour of the foliage and rose hips. In winter admire the varied forms of the rose.", exhibitionLat: -37.830675, exhibitionLon: 144.983375, icon: "rose").0
        
        //9
        let p25 = addPlant(name: "yellow rose", family: "Rosaceae", imageOfPlant: "https://bs.floristic.org/image/o/6416eb252e4e3d359aa298647c1568ed8ad03b90", scientificName: "Rosa xanthina", yearDiscovered: 1820)
        let p26 = addPlant(name: "Tropical bushmint", family: "Lamiaceae", imageOfPlant: "https://bs.floristic.org/image/o/6d6e4508351df724030893242a89a8ab8e6a0808", scientificName: "Cantinoa mutabilis", yearDiscovered: 2012)
        let p27 = addPlant(name: "yellow pitcherplant", family: "Sarraceniaceae", imageOfPlant: "https://bs.floristic.org/image/o/0f951952a85218983aadd276968c513c76f8af96", scientificName: "Sarracenia flava", yearDiscovered: 1753)

        let _ = addPlantToExhibit(plant: p25, exhibition: ex9)
        let _ = addPlantToExhibit(plant: p26, exhibition: ex9)
        let _ = addPlantToExhibit(plant: p27, exhibition: ex9)
        
        //  MARK: - Exhibition 10
        let ex10 = addExhibition(name: "Lower Yarra River Habitat", desc: "An ecological collection to display and conserve Indigenous plants from five plant communities found locally in the lower Yarra region. This area has been transformed to display a significant collection of five Indigenous plant communities. The planting of both terrestrial and wetland species from these fragmented plant communities have increased the Melbourne Gardens' Indigenous plant biodiversity.", exhibitionLat: -37.828107, exhibitionLon: 144.980114, icon: "leaf").0
        
        //10
        let p28 = addPlant(name: "Water ribbon", family: "Juncaginaceae", imageOfPlant: "https://bs.floristic.org/image/o/60868ac03e4a9d39bc54f9b8aff113d71e5c455a", scientificName: "Cycnogeton procerum", yearDiscovered: 1868)
        let p29 = addPlant(name: "White correa", family: "Rutaceae", imageOfPlant: "https://bs.floristic.org/image/o/ca3a30cefb1ccaac2170f635ccf904568ee12ce5", scientificName: "Correa alba", yearDiscovered: 1798)
        let p30 = addPlant(name: "Christmasbush", family: "Cunoniaceae", imageOfPlant: "https://bs.floristic.org/image/o/eb49be3a4dc95e1510ddbbaf9f08f7cb7a3692e8", scientificName: "Ceratopetalum gummiferum", yearDiscovered: 1793)
        let _ = addPlantToExhibit(plant: p28, exhibition: ex10)
        let _ = addPlantToExhibit(plant: p29, exhibition: ex10)
        let _ = addPlantToExhibit(plant: p30, exhibition: ex10)
        
        
        /// not required
        var plants: [Plant] = []
        plants.append(contentsOf: [p1, p2, p3, p4, p5, p6, p7, p8, p9, p10, p11, p12, p13, p14, p15, p16, p17, p18, p19, p10,p21, p22, p23, p24, p25, p26, p27, p28, p29, p30])
        saveContext()
    }

     
    
    
    
}

