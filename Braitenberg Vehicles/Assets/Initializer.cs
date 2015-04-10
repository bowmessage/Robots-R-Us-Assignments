using UnityEngine;
using System.Collections;


public class Initializer : MonoBehaviour {

	public GameObject Vehicle;

	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
	
	}

	void OnGUI() {

		if (GUI.Button (new Rect (20, 40, 80, 20), "Start")) {

		}
	}

	void OnMouseDown() {
		Ray ray = Camera.main.ScreenPointToRay (Input.mousePosition);
		RaycastHit hit = new RaycastHit();
		if (Physics.Raycast (ray, out hit)) {
			Instantiate(Vehicle, hit.point, Quaternion.identity); 
		}
	}
}
