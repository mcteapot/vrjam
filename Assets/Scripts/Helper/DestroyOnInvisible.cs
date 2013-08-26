using UnityEngine;
using System.Collections;

public class DestroyOnInvisible : MonoBehaviour
{
	public bool destroySelf = true;
	public GameObject[] destroyObjects;
	
	void OnBecameInvisible()
	{
		if(destroySelf)
		{
			Destroy(gameObject);
		}
		foreach(GameObject obj in destroyObjects)
		{
			Destroy(obj);
		}
	}
}
