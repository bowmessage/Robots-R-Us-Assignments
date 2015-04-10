using UnityEngine;
using System.Collections;

public class WarpWall : MonoBehaviour
{

    public Transform otherWall;
    public enum wallType
    {
        horizontal,
        vertical
    }
    public wallType type;
    public float warpOffset;

    void OnTriggerEnter(Collider other)
    {
        if (other.CompareTag("VehicleBody"))
        {
            if (type == wallType.horizontal)
            {
                //gotta shift all 3 parts by same amount.
                //other = vehicle body
                other.transform.position = new Vector3(otherWall.position.x  + warpOffset, other.transform.position.y, other.transform.position.z);
                //wheels, ugly but who cares.
                Transform w1 = other.transform.parent.GetChild(0).transform;
                Transform w2 = other.transform.parent.GetChild(1).transform;
                w1.position = new Vector3(otherWall.position.x + warpOffset, w1.position.y, w1.position.z);
                w2.position = new Vector3(otherWall.position.x + warpOffset, w2.position.y, w2.position.z);
            }
            else
            {
                //gotta shift all 3 parts by same amount.
                //other = vehicle body
                other.transform.position = new Vector3(other.transform.position.x, other.transform.position.y, otherWall.position.z + warpOffset);
                //wheels, ugly but who cares.
                Transform w1 = other.transform.parent.GetChild(0).transform;
                Transform w2 = other.transform.parent.GetChild(1).transform;
                w1.position = new Vector3(w1.position.x, w1.position.y, otherWall.position.z + warpOffset);
                w2.position = new Vector3(w2.position.x, w2.position.y, otherWall.position.z + warpOffset);
            }
        }
    }
}
