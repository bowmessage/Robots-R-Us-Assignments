using UnityEngine;
using System.Collections;


public class Initializer : MonoBehaviour {

	public GameObject Vehicle;

	public string k00 = "0";
	public string k01 = "0";
	public string k10 = "0";
	public string k11 = "0";

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnGUI() {
		//GUILayout.BeginArea (new Rect (10, 10, 100, 100));
		GUILayout.BeginHorizontal ("");
		k00 = GUILayout.TextField (k00, GUILayout.Width (40));
		k01 = GUILayout.TextField (k01, GUILayout.Width (40));
		GUILayout.EndHorizontal ();

		GUILayout.BeginHorizontal ("");
		k10 = GUILayout.TextField (k10, GUILayout.Width (40));
		k11 = GUILayout.TextField (k11, GUILayout.Width (40));
		GUILayout.EndHorizontal ();
		//GUILayout.EndArea ();
	}

	void OnMouseDown() {
		Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
		RaycastHit hit = new RaycastHit();
		if (Physics.Raycast (ray, out hit)) {
			Instantiate(Vehicle, hit.point, Quaternion.identity); 
		}
	}
}
