using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.UI;

public class BeerInformationHandler : MonoBehaviour
{
    public Button informationButton; 
    private PopupWorld popupWorld;

    void Start()
    {
        popupWorld = FindObjectOfType<PopupWorld>();
        informationButton.onClick.AddListener(SendPostRequest);
    }

    void SendPostRequest()
    {
        Debug.Log("Sended message!");
    }
}
