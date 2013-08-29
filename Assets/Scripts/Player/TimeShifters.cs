using UnityEngine;
using System.Collections;

public class TimeShifters : MonoBehaviour {
	
	public enum OSSetup {
		mac,
		pc
	};
	
	public OSSetup ossetups = OSSetup.mac;
	
	public float slowSpeed = 0.3f;
	public float slowDownTimer = 2.0f;
	public float speedUpTimer = 1.0f;
	
	private float timeAxis;
	private bool readyToShiftTrigger = false;
	
	private bool timeSlow = false;
	
	
	// Use this for initialization
	void Start () {
		timeAxis = Input.GetAxisRaw("TimeShift");
	}
	
	// Update is called once per frame
	void Update () {
		if(ossetups == OSSetup.mac) {
			
			//TimeManager.Instance.SetTimeScale(macReadTrigger());
			//macReadTrigger();
			//TimeManager.Instance.ChangeTimeScale(macReadTrigger(),5.5f);
			
			if(macReadTrigger() != 1.0f && timeSlow == false) {
				timeSlow = true;
				//Debug.Log("TIME SLOW");
				TimeManager.Instance.ChangeTimeScale(slowSpeed, slowDownTimer);
			} else if(macReadTrigger() == 1.0f && timeSlow == true) {
				timeSlow = false;
				//Debug.Log("TIME FAST");
				TimeManager.Instance.ChangeTimeScale(1.0f, speedUpTimer);	
			}
			
		} else {
			//Debug.Log("PC"); //remove inversion on inputmanager for timeShifter
			
			timeAxis = Input.GetAxisRaw("TimeShift");
			
			if(timeAxis != 0.0f && timeSlow == false) {
				timeSlow = true;
				//Debug.Log("TIME SLOW");
				TimeManager.Instance.ChangeTimeScale(slowSpeed, slowDownTimer);
			} else if(timeAxis == 0.0f && timeSlow == true) {
				timeSlow = false;
				//Debug.Log("TIME FAST");
				TimeManager.Instance.ChangeTimeScale(1.0f, speedUpTimer);	
			}
			
		}
	}
	
	float macReadTrigger () {
		
		float adjustedAxis = 1.0f;
		timeAxis = Input.GetAxisRaw("TimeShift");

		if((timeAxis > -0.9f && timeAxis < -0.0001f) && readyToShiftTrigger == false) {
			readyToShiftTrigger = true;
		}
		
		if(readyToShiftTrigger) {
			//Debug.Log("TIME SHIT: " + timeAxis);
			if(timeAxis == -1) {
				adjustedAxis = 0;
			} else if(timeAxis > -1 && timeAxis < 0) {
				adjustedAxis = (timeAxis * -1.0f) * 0.5f;
			} else if(timeAxis == 0) {
				adjustedAxis = 0.5f;
			} else if(timeAxis > 0 && timeAxis < 1) {
				adjustedAxis = (timeAxis + 1.0f) * 0.5f;  
			} else if(timeAxis == 1) {
				adjustedAxis = 1;
			}
			
			//Debug.Log("TIME ADJUST: " + adjustedAxis);
		}
		

		return adjustedAxis;
	}
	
	
}
