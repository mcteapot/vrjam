using UnityEngine;
using System.Collections;

[RequireComponent (typeof(AudioSource))]
public class AdjustPitchToTimeScale : MonoBehaviour
{
	// Update is called once per frame
	void Update ()
	{
		audio.pitch = Time.timeScale;
	}
}
