using Newtonsoft.Json;
using System.Collections.Generic;
using UnityEngine;

public class TargetBeer : MonoBehaviour
{
    private Beer beer;

    private PopupWorld popupworld;

    [System.Serializable]
    public class Beer
    {
        public int id;
        public string name;
        public string brewery;
        public double rating;
        public string description;
        public List<string> countries;
    }

    void Start()
    {
        popupworld = FindObjectOfType<PopupWorld>();
    }

    void Update()
    {
        
    }

    void SetTargetBeer(string targetBeerJsonString)
    {
        beer = JsonConvert.DeserializeObject<Beer>(targetBeerJsonString);
        popupworld.PlacePins(beer.countries);
        popupworld.world.SetActive(true);
    }
}
