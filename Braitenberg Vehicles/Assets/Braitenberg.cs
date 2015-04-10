using UnityEngine;
using System.Collections;
using System.Collections.Generic;

public class Braitenberg : MonoBehaviour
{

    public Rigidbody leftWheel;
    public Rigidbody rightWheel;
    public Transform body;

    public Transform leftSensor;
    public Transform rightSensor;

    public List<Transform> lights = new List<Transform>();

    //gotta do k matrix in a stupid way to see it in inspector...
    [System.Serializable]
    public class KMatrix{
        public float K11 = 0;
        public float K12 = 0;
        public float K21 = 0;
        public float K22 = 0;
    }
    public KMatrix k;
    public float speedMultiplier;
    // Use this for initialization
    void Start()
    {
        //find all light sources for this simulation
        foreach(GameObject l in GameObject.FindGameObjectsWithTag("Light"))
        {
            lights.Add(l.transform);
        }
    }

    void Update()
    {
        float leftSensorValue = 0;
        float rightSensorValue = 0;
        foreach (Transform l in lights)
        {
            leftSensorValue += 100 / Vector3.Distance(new Vector3(l.position.x, leftSensor.position.y, l.position.z), leftSensor.position);
            rightSensorValue += 100 / Vector3.Distance(new Vector3(l.position.x, rightSensor.position.y, l.position.z), rightSensor.position);
            //Debug.Log("Left : " +leftSensorValue + ", Right : " + rightSensorValue);
        }
        leftWheel.velocity = body.forward * speedMultiplier * (k.K11 * leftSensorValue + k.K12 * rightSensorValue);
        rightWheel.velocity = body.forward * speedMultiplier * (k.K21 * leftSensorValue + k.K22 * rightSensorValue);
        //Debug.Log("Left : " + leftWheel.velocity.magnitude + ", Right : " + rightWheel.velocity.magnitude);
    }
}
