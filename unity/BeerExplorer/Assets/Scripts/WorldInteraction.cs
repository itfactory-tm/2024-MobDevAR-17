using UnityEngine;

public class WorldInteraction : MonoBehaviour
{
    public float rotationSpeed;
    private Vector3 lastMousePosition;
    private bool isDragging = false;

    private Camera mainCamera;

    void Start()
    {
        mainCamera = Camera.main; // Pak de hoofdcamera
    }

    void Update()
    {
        // Rotatie
        HandleRotation();
    }

    private void HandleRotation()
    {
        // Muis Invoer
        if (Input.GetMouseButtonDown(0)) // Als je de muisknop indrukt
        {
            isDragging = true;
            lastMousePosition = Input.mousePosition; // Sla de huidige positie van de muis op
        }
        else if (Input.GetMouseButtonUp(0)) // Als je de muisknop loslaat
        {
            isDragging = false;
        }

        if (isDragging)
        {
            Vector3 currentMousePosition = Input.mousePosition;
            Vector3 delta = currentMousePosition - lastMousePosition; // Bepaal de verandering in de muispositie

            // Draai de wereld op basis van de verandering in de horizontale en verticale posities
            float rotationX = delta.y * rotationSpeed * Time.deltaTime; // Verticaal (om de X-as)
            float rotationY = -delta.x * rotationSpeed * Time.deltaTime; // Horizontaal (om de Y-as)

            // Draai de wereldbol rond zijn eigen X-as en Y-as
            transform.Rotate(Vector3.right, rotationX, Space.World); // Verticaal bewegen
            transform.Rotate(Vector3.up, rotationY, Space.World); // Horizontaal bewegen

            lastMousePosition = currentMousePosition; // Update de muispositie voor de volgende frame
        }

        // Voor Mobiele Vegen
        if (Input.touchCount == 1) // Als er één aanraking is
        {
            Touch touch = Input.GetTouch(0);

            if (touch.phase == TouchPhase.Moved) // Als je de vinger beweegt
            {
                Vector2 delta = touch.deltaPosition; // Krijg de verandering in de vingerpositie

                // Draai de wereld op basis van de verandering in de horizontale en verticale posities
                float rotationX = delta.y * rotationSpeed * Time.deltaTime; // Verticaal (om de X-as)
                float rotationY = -delta.x * rotationSpeed * Time.deltaTime; // Horizontaal (om de Y-as)

                // Draai de wereldbol rond zijn eigen X-as en Y-as
                transform.Rotate(Vector3.right, rotationX, Space.World); // Verticaal bewegen
                transform.Rotate(Vector3.up, rotationY, Space.World); // Horizontaal bewegen
            }
        }
    }
}
