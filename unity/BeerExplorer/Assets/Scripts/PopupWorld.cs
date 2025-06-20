using UnityEngine;
using System.Collections.Generic;
using FlutterUnityIntegration;
using System.Collections;

public class PopupWorld : DefaultObserverEventHandler
{
    public GameObject world;
    public string _name;

    private readonly Dictionary<string, Coord> coordsMap = new Dictionary<string, Coord>();

    private readonly Dictionary<string, GameObject> pins =  new Dictionary<string, GameObject>();

    public GameObject pinPrefab;
    private readonly float radius = 10f;
    public float distanceFromCamera = 2.0f;

    protected override void Start()
    {
        base.Start();
        ReadCoords();  
    }

    void Update() {
        if (!world.activeSelf && pins.Count > 0)
        {
            foreach (var pin in pins.Values) Destroy(pin);
            pins.Clear();
        }

        if (world.activeSelf) centerGameObject(world, Camera.main, 33.0f);
    }

    protected override void OnTrackingFound()
    {
        base.OnTrackingFound();
        // PlacePins(countries);

        // Stuur het bericht naar Flutter
        UnityMessageManager.Instance.SendMessageToFlutter(JsonUtility.ToJson(
            new TrackedObjectMessageFlutter() { key = "TrackedObject", name = _name }
        ));
    }

    protected override void OnTrackingLost()
    {
        base.OnTrackingLost();
    }

    public void PlacePins(List<string> countries) {
        foreach (var country in countries) 
        {
            Coord coord = coordsMap[country];
            Vector3 position = CalculatePosition(coord.latitude, coord.longitude);
            Quaternion rotation = CalculateRotation(position);
            pins[country] = Instantiate(pinPrefab, position, rotation, world.transform);
        }
    }

    void centerGameObject(GameObject gameOBJToCenter, Camera cameraToCenterOBjectTo, float zOffset = 2.6f)
    {
        gameOBJToCenter.transform.position = cameraToCenterOBjectTo.ViewportToWorldPoint(new Vector3(0.5f, 0.5f, cameraToCenterOBjectTo.nearClipPlane + zOffset));
    }

    private void ReadCoords() {
        Debug.Log("reading the coords!");

        TextAsset jsonFile = Resources.Load<TextAsset>("countries");
        if (jsonFile != null)
        {
            CoordList coordList = JsonUtility.FromJson<CoordList>(jsonFile.text);

            foreach (var coord in coordList.beerCoords)
            {
                coordsMap[coord.name] = new Coord() {
                    longitude = coord.longitude,
                    latitude = coord.latitude
                };
            }
        }
        else
        {
            Debug.LogError("Kon JSON-bestand niet vinden in Resources!");
        }
    }

    private Vector3 CalculatePosition(float latitude, float longitude)
    {
        Vector3 point = new Vector3(radius, 0, 0);
        point = Quaternion.Euler(0, -longitude, latitude) * point;
        return point;
    }

    private Quaternion CalculateRotation(Vector3 position)
    {
        // Bereken de normale vector (richting naar het middelpunt van de bol)
        Vector3 directionToCenter = -position.normalized;

        // Bereken de rotatie die de pin naar het midden richt
        Quaternion rotation = Quaternion.LookRotation(directionToCenter);

        // Pas een offset aan om de pin correct te positioneren (x=0, y=90, z=-90)
        Quaternion offset = Quaternion.Euler(180, 0, 0);

        return rotation * offset;
    }

    [System.Serializable]
    public class Coord
    {
        public float longitude;
        public float latitude;
    }

    [System.Serializable]
    public class CoordList
    {
        public BeerCoord[] beerCoords;
    }

    [System.Serializable]
    public class BeerCoord
    {
        public string name;
        public float longitude;
        public float latitude;
    }

    [System.Serializable]
    public class TrackedObjectMessageFlutter
    {
        public string key;
        public string name;
    }
}
