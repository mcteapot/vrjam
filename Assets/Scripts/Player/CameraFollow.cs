using UnityEngine;
using System.Collections;

public class CameraFollow : MonoBehaviour {
	
	public enum CameraStates {
		forward,
		backward
	};
	
	public CameraStates cameraState = CameraStates.backward;
	
	public Transform cameraForward;
	public Transform cameraForwardRift;
	public Transform cameraBack;
	
	public Transform cameraRiftNull;
	
	public Transform shipWindow;
	
	public float followSpeed = 3.0f;
	
	private bool transitioning = false;
	private Vector3 backRotation = new Vector3(0, 0, 0);

	// Use this for initialization
	void Start () {
		if(cameraState == CameraStates.backward) {
			shipWindow.gameObject.SetActive(true);
			transform.position = cameraBack.position;
		} else if(cameraState == CameraStates.forward) {
			shipWindow.gameObject.SetActive(false);
			if(cameraRiftNull.gameObject.activeSelf) {
				transform.position = cameraForwardRift.position;
				transform.localRotation =  cameraForwardRift.rotation;
			} else {
				transform.position = cameraForward.position;
				transform.rotation =  cameraForward.rotation;
			}
		}
	
	}
	void Update () {
		jumpCamera();

	}
	// Update is called once per frame
	
	void LateUpdate () {
		updateCameraPosition();
	
	}
	
	
	void jumpCamera () {
		if(Input.GetButtonDown("Camera Jump")) {
			//Debug.Log("FUCKING JUMP");
			if(!transitioning) {
				transitioning = true;
				if(cameraState == CameraStates.backward) {
					shipWindow.gameObject.SetActive(false);
					cameraState = CameraStates.forward;
					
					if(cameraRiftNull.gameObject.activeSelf) {
						transform.position = cameraForwardRift.position;
						transform.localRotation =  cameraForwardRift.rotation;
					} else {
						transform.position = cameraForward.position;
						transform.rotation =  cameraForward.rotation;
					}

					transitioning = false;
					
				} else if(cameraState == CameraStates.forward) {
					shipWindow.gameObject.SetActive(true);
					cameraState = CameraStates.backward;
					transform.position = cameraBack.position;
					transform.rotation = cameraBack.rotation;
					transitioning = false;
				}	
			}
		}
	}
	void updateCameraPosition () {
		if(!transitioning && cameraState == CameraStates.backward) {
			shipWindow.gameObject.SetActive(true);
			transform.position = Vector3.Lerp(transform.position, cameraBack.position, followSpeed * Time.deltaTime);
			transform.rotation = Quaternion.Euler(backRotation);
		} else if(!transitioning && cameraState == CameraStates.forward) {
			shipWindow.gameObject.SetActive(false);
			if(cameraRiftNull.gameObject.activeSelf) {
				transform.position = cameraForwardRift.position;
				transform.localRotation =  cameraForwardRift.rotation;
			} else {
				transform.position = cameraForward.position;
				transform.rotation =  cameraForward.rotation;
			}
		}
		
	}
}
