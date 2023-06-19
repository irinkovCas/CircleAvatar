using System;
using System.Collections;
using UnityEngine;
using UnityEngine.Networking;
using UnityEngine.UI;

public class Main : MonoBehaviour
{
    public RawImage rawImage_0;
    public RawImage rawImage_1;
    public RawImage rawImage_2;

    public Texture existingTexture;
    public Shader circularShader;

    RenderTexture renderTexture;

    // public string url_0 = "https://cdn-dev-reydomino.cgp.one/uploads/avatars/cefcc9e4-66b3-4297-b4b8-eac3178b5237.jpg";
    private string url_0 = "https://upload.wikimedia.org/wikipedia/commons/thumb/a/a8/TEIDE.JPG/1920px-TEIDE.JPG";
    private string url_1 = "https://images.pexels.com/photos/12833513/pexels-photo-12833513.jpeg?auto=compress&cs=tinysrgb&w=1260&h=750&dpr=1";
    private string url_2 = "https://belotbg.s3.eu-central-1.amazonaws.com/uploads/avatars/93e13108-9c6c-4487-bd21-55e078b63a29.jpg";

    void Start()
    {
        SetImage(rawImage_0, url_0);
        SetImage(rawImage_1, url_1);
        SetImage(rawImage_2, url_2);
    }

    void SetImage(RawImage rawImage, string url)
    {
        StartCoroutine(SetImageCoroutine(rawImage, url));
    }

    private IEnumerator SetImageCoroutine(RawImage rawImage, string url)
    {
        using (UnityWebRequest webRequest = UnityWebRequestTexture.GetTexture(url))
        {
            // Request and wait for the desired page.
            yield return webRequest.SendWebRequest();

            if (webRequest.result == UnityWebRequest.Result.ConnectionError ||
                webRequest.result == UnityWebRequest.Result.ProtocolError)
            {
                Debug.Log($"{webRequest.error}: {webRequest.downloadHandler.text}");
            }
            else
            {
                try
                {
                    Texture texture = DownloadHandlerTexture.GetContent(webRequest);

                    // // create a render texture with the same dimensions as the texture and an alpha channel
                    renderTexture = new RenderTexture(texture.width, texture.height, 0, RenderTextureFormat.ARGBFloat);

                    renderTexture.Create();


                    // set the rendertexutre color to red
                    // Graphics.SetRenderTarget(renderTexture);
                    // GL.Clear(true, true, Color.clear);

                    // // unbind the rendertexture
                    // Graphics.SetRenderTarget(null);

                    Material circularMaterial = new Material(circularShader);

                    // circularMaterial.SetTexture("_MainTex", texture);
                    Graphics.Blit(texture, renderTexture, circularMaterial);

                    GameObject.Destroy(texture);

                    rawImage.texture = renderTexture;
                    rawImage.SetNativeSize();
                }
                catch (System.Exception e)
                {
                    Debug.LogException(e);
                }
            }
        }
    }
}
