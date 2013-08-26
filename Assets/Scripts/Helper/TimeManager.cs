using UnityEngine;
using System.Collections;

public class TimeManager : MonoBehaviour
{	
	public float realDeltaTime { get { return Time.deltaTime*Time.timeScale; } }
	
	private float originalFixedDeltaTime;
	private float originalTimeScale;
	private float newTimeScale;
	private float transitionT;
	
	public void SetTimeScale( float timeScale) {
		Time.timeScale = timeScale;
	}
	
	
	public void ChangeTimeScale(float timeScale, float transitionTime = 0.0f)
	{
		originalTimeScale = Time.timeScale;
		newTimeScale = timeScale;
		transitionT = transitionTime;
		
		StopAllCoroutines();
		StartCoroutine("TransitionTimeScale");
		Time.timeScale = timeScale;
		Time.fixedDeltaTime = originalFixedDeltaTime * newTimeScale;
	}
	
	private IEnumerator TransitionTimeScale()
	{
		float t = 0;
		
		while(t < transitionT)
		{
			Time.timeScale = Mathf.Lerp(originalTimeScale,newTimeScale,t/transitionT);
			Time.fixedDeltaTime = originalFixedDeltaTime * Time.timeScale;
			t += Time.deltaTime/Time.timeScale;
			yield return null;
		}
		Time.timeScale = newTimeScale;
		Time.fixedDeltaTime = originalFixedDeltaTime * Time.timeScale;
	}
	
	#region Singleton stuff
	private static TimeManager instance = null;
	
	public static TimeManager Instance
	{
		get { return instance ?? (instance = new GameObject("$TimeManager").AddComponent<TimeManager>()); }
	}
	
	void Awake()
	{
		originalFixedDeltaTime = Time.fixedDeltaTime;
		if (instance != null && instance != this)
		{
			Destroy(this.gameObject);
			return;
		}
		else
		{
			instance = this;
		}
		DontDestroyOnLoad(this.gameObject);
		name = "$TimeManager";
	}
	#endregion
}
