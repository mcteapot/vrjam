using UnityEngine;
using System.Collections;

public class RandomRotation : MonoBehaviour {
	
		

	// Use this for initialization
	void Start () {
		transform.rotation = Quaternion.Euler( new Vector3(0, Random.Range(0, 360), 0));
		transform.localScale = new Vector3(Random.Range(2.0f, 2.80f), Random.Range(1.7f, 3.10f), Random.Range(2.0f, 2.80f));
	}
	
	// Update is called once per frame
	void Update () {
	
	}
}
