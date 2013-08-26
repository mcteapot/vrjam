using UnityEngine;
using System.Collections;

public class DestoryAtPositionLazer : MonoBehaviour {
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		Debug.Log(transform.localPosition.z);
		Debug.Log(transform.position.z);
		if(transform.position.z > 150.0f) {
			Debug.Log("TRANSFOR GREATER");
			Destroy(gameObject);
		}
	}
}
