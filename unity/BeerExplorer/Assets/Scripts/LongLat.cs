using System.Collections;
using System.Collections.Generic;
using UnityEngine;

public class LongLat : MonoBehaviour
{
    [System.Serializable]
    public class Point
    {
        public float longitude;
        public float latitude;
    }

    public List<Point> points = new List<Point>();
    private List<GameObject> pins = new List<GameObject>();

    public GameObject pinPrefab;
    private readonly float radius = 10f;

    private void Start()
    {
        // UpdatePins();
    }

    private void OnValidate()
    {
    //    UpdatePins();
    }

    private void UpdatePins()
    {
        foreach (var pin in pins) Destroy(pin);
        pins.Clear();

        foreach (var point in points)
        {
            Vector3 position = CalculatePosition(point.longitude, point.latitude);
            Quaternion rotation = CalculateRotation(position);
            GameObject pin = Instantiate(pinPrefab, position, rotation, transform);

            pins.Add(pin);
        }
    }

    private Vector3 CalculatePosition(float longitude, float latitude)
    {
        Vector3 point = new Vector3(radius, 0, 0);
        point = Quaternion.Euler(0, -latitude, longitude) * point;
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
}
