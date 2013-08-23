using UnityEngine;
using System.Collections;

public class ShipThruster : MonoBehaviour
{
	public Material[] materialsToChange;
	public float saturation = 1.0f;
	public float brightness = 1.0f;
	public float alpha = 1.0f;
	
	// Update is called once per frame
	void FixedUpdate ()
	{
		float hueColor = 0.99f;
		if(Random.Range(0, 3) == 1) {
			hueColor = 0.07f;
		}
		
		Debug.Log("HUECOLOR " + hueColor);
		HSBColor newColor = new HSBColor(hueColor,saturation,brightness,alpha);
		
		foreach(Material mat in materialsToChange)
		{	
			mat.color = newColor.ToColor();
		}
	}
}
