using Newtonsoft.Json;
using UnityEngine;

public class WorldVisibility : MonoBehaviour
{
    public GameObject world;

    void Start()
    {
        
    }

    // Update is called once per frame
    void Update()
    {
        
    }

    void SetWorldVisibility(string worldVisibility)
    {
        world.SetActive(JsonConvert.DeserializeObject<bool>(worldVisibility));
    }
}
