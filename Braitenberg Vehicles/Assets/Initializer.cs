using UnityEngine;
using System.Collections.Generic;


public class Initializer : MonoBehaviour {

	public GameObject Vehicle;
    public GameObject Light;

    public enum simState
    {
        lightSetup,
        vehicleSetup,
        simulating
    }
    public simState state;

    public List<Transform> lights = new List<Transform>();
    public List<Braitenberg> vehicles = new List<Braitenberg>();

    public string k00 = "0";
    public string k01 = "0";
    public string k10 = "0";
    public string k11 = "0";
    public string theta = "0";
	// Update is called once per frame
	void Update () {
	    switch(state)
        {
            case simState.lightSetup:
                if(Input.GetMouseButtonDown(0) && GUIUtility.hotControl == 0)
                {
                    Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                    RaycastHit hit;
                    if (Physics.Raycast(ray, out hit))
                    {
                        if (hit.collider.CompareTag("Floor"))
                        {
                            GameObject newLight = Instantiate(Light,new Vector3(hit.point.x, 4, hit.point.z), Quaternion.identity) as GameObject;
                            lights.Add(newLight.transform);
                        }
                    }
                }
                break;
            case simState.vehicleSetup:
                if (Input.GetMouseButtonDown(0) && GUIUtility.hotControl == 0)
                {
                    Ray ray = Camera.main.ScreenPointToRay(Input.mousePosition);
                    RaycastHit hit;
                    if (Physics.Raycast(ray, out hit))
                    {
                        if (hit.collider.CompareTag("Floor"))
                        {
                            GameObject newVehicle = Instantiate(Vehicle, new Vector3(hit.point.x, 0.1f, hit.point.z), Quaternion.Euler(0, float.Parse(theta), 0) * Quaternion.identity) as GameObject;
                            vehicles.Add(newVehicle.GetComponent<Braitenberg>());
                            vehicles[vehicles.Count-1].k.K11 = float.Parse(k00);
                            vehicles[vehicles.Count-1].k.K12 = float.Parse(k01);
                            vehicles[vehicles.Count-1].k.K21 = float.Parse(k10);
                            vehicles[vehicles.Count-1].k.K22 = float.Parse(k11);
                        }
                    }
                }
                break;
        }
	}

	void OnGUI() {

        switch (state)
        {
            case simState.lightSetup:
                if (GUI.Button(new Rect(20, 80, 80, 20), "Next"))
                {
                    state = simState.vehicleSetup;
                }
                break;
            case simState.vehicleSetup:
                if (GUI.Button(new Rect(20, 80, 80, 20), "Start"))
                {
                    state = simState.simulating;
                    foreach(Braitenberg v in vehicles)
                    {
                        v.lights = lights;
                        v.simRunning = true;
                    }
                }
                GUILayout.BeginHorizontal("");
                GUILayout.Label("k00");
                k00 = GUILayout.TextField(k00, GUILayout.Width(40));
                GUILayout.Label("k01");
                k01 = GUILayout.TextField(k01, GUILayout.Width(40));
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal("");
                GUILayout.Label("k10");
                k10 = GUILayout.TextField(k10, GUILayout.Width(40));
                GUILayout.Label("k11");
                k11 = GUILayout.TextField(k11, GUILayout.Width(40));
                GUILayout.EndHorizontal();

                GUILayout.BeginHorizontal("");
                GUILayout.Label("theta");
                theta = GUILayout.TextField(theta, GUILayout.Width(40));
                GUILayout.EndHorizontal();
                break;
            case simState.simulating:
                if (GUI.Button(new Rect(20, 80, 80, 20), "New Sim"))
                {
                    foreach(Braitenberg v in vehicles)
                    {
                        Destroy(v.gameObject);
                    }
                    foreach(Transform l in lights)
                    {
                        Destroy(l.gameObject);
                    }
                    vehicles.Clear();
                    lights.Clear();
                    state = simState.lightSetup;
                }
                break;

        }
		
	}
}
