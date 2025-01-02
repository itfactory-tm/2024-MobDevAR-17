using System.Collections;
using FlutterUnityIntegration;
using UnityEngine;
using UnityEngine.Networking;
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
        if (popupWorld.response != null)
        {
            UnityMessageManager.Instance.SendMessageToFlutter(JsonUtility.ToJson(popupWorld.response));
        }
    }
}
