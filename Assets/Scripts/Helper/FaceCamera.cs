using UnityEngine;
using System.Collections;

public class FaceCamera : MonoBehaviour {
	
    public Transform m_Camera;
 
    void Update()
    {
        transform.LookAt(transform.position + m_Camera.rotation * Vector3.forward, m_Camera.rotation * Vector3.up);
	
    }
}
