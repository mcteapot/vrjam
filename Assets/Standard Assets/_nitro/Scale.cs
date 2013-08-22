using UnityEngine;
using System.Collections;

public class Scale : MonoBehaviour
{

	public ParticleEmitter[] particleEmitters;
	public float scale = 1;

	private float[] minsize;


	private float[] maxsize;


	private Vector3[] worldvelocity;


	private Vector3[] localvelocity;


	private Vector3[] rndvelocity;


	private Vector3[] scaleBackUp;


	private bool firstUpdate = true;


	public void UpdateScale ()
	{
		int length = particleEmitters.Length;
		
		if (firstUpdate == true) {
			minsize = new float[length];
			maxsize = new float[length];
			worldvelocity = new Vector3[length];
			localvelocity = new Vector3[length];
			rndvelocity = new Vector3[length];
			scaleBackUp = new Vector3[length];
		}
		
		
		for (int i = 0; i < particleEmitters.Length; i++) {
			if (firstUpdate == true) {
				minsize[i] = particleEmitters[i].minSize;
				maxsize[i] = particleEmitters[i].maxSize;
				worldvelocity[i] = particleEmitters[i].worldVelocity;
				localvelocity[i] = particleEmitters[i].localVelocity;
				rndvelocity[i] = particleEmitters[i].rndVelocity;
				scaleBackUp[i] = particleEmitters[i].transform.localScale;
			}
			
			particleEmitters[i].minSize = minsize[i] * scale;
			particleEmitters[i].maxSize = maxsize[i] * scale;
			particleEmitters[i].worldVelocity = worldvelocity[i] * scale;
			particleEmitters[i].localVelocity = localvelocity[i] * scale;
			particleEmitters[i].rndVelocity = rndvelocity[i] * scale;
			particleEmitters[i].transform.localScale = scaleBackUp[i] * scale;
			
		}
		firstUpdate = false;
	}
}
