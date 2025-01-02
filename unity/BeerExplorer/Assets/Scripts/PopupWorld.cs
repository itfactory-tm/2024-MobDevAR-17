using UnityEngine;
using System.Net.Http;
using System;
using Newtonsoft.Json;
using System.Collections.Generic;

public class PopupWorld : DefaultObserverEventHandler
{
    public GameObject world;
    public string _name;
    private readonly string BASE_URL = "https://beer9.p.rapidapi.com/?name=";

    private CoordList coordList;

    private Dictionary<string, Coord> coordsMap = new Dictionary<string, Coord>();

    private Dictionary<string, GameObject> pins =  new Dictionary<string, GameObject>();

    public GameObject pinPrefab;
    private readonly float radius = 10f;
    public float distanceFromCamera = 2.0f;

    public Response response = null;

    protected override void Start()
    {
        base.Start();
        ReadCoords();
    }

    protected override void OnTrackingFound()
    {
        base.OnTrackingFound();
        world.SetActive(true);

        foreach (var pin in pins.Values) Destroy(pin);
        pins.Clear();
        FetchDataFromAPI();
    }

    protected override void OnTrackingLost()
    {
        base.OnTrackingLost();
    }

    private async void FetchDataFromAPI()
    {
        var client = new HttpClient();
        var request = new HttpRequestMessage
        {
            Method = HttpMethod.Get,
            RequestUri = new Uri(BASE_URL + _name),
            Headers =
            {
                { "x-rapidapi-key", "130c7a561dmsh8797bd33efe156bp10b165jsn031a49e870ec" },
                { "x-rapidapi-host", "beer9.p.rapidapi.com" },
            },
        };

        using (var res = await client.SendAsync(request))
        {
            res.EnsureSuccessStatusCode();
            var body = await res.Content.ReadAsStringAsync();
            response = JsonConvert.DeserializeObject<Response>(body);
      
            foreach (var r in response.data)
            {
                if (!pins.ContainsKey(r.country))
                {
                    Coord coord = coordsMap[r.country];
                    Vector3 position = CalculatePosition(coord.latitude, coord.longitude);
                    Quaternion rotation = CalculateRotation(position);
                    pins[r.country] = Instantiate(pinPrefab, position, rotation, world.transform);
                }
            }
        }
    }

    private void ReadCoords() {
        Debug.Log("reading the coords!");

        TextAsset jsonFile = Resources.Load<TextAsset>("countries");
        if (jsonFile != null)
        {
            coordList = JsonUtility.FromJson<CoordList>(jsonFile.text);

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
    public class Response
    {
        public string code;
        public string error;
        public BeerResponse[] data;
    }

    [System.Serializable]
    public class BeerResponse
    {
        public string sku;
        public string name;
        public string brewery;
        public string rating;
        public string description;
        public string country;
    }
}
