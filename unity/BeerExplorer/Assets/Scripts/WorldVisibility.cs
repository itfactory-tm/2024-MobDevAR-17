using Newtonsoft.Json;
using UnityEngine;

public class WorldVisibility : MonoBehaviour
{
    public GameObject world;

    private Quaternion defaultRotation = Quaternion.Euler(-7.722f, -40.598f, 1.169f);

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
        world.transform.rotation = defaultRotation;
    }
}
