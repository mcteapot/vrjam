using UnityEngine;
using System.Collections;

public class ShipMovement : MonoBehaviour
{
	public float movementSpeed = 1.0f;
	public float rotationSpeed = 1.0f;
	public float returnRotationSpeed = 1.0f;
	public float maxRotationHorizon = 30.0f;
	public float maxRotationVertical = 20.0f;
	public int invert = -1; //Negative 1 for invert, positive 1 for not
	
	// Update is called once per frame
	void Update ()
	{
		shipMove();
	}
	
	void shipMove () {
		float horizontal = Input.GetAxis("Horizontal");
		float vertical = Input.GetAxis("Vertical");
		
		Vector3 direction = new Vector3(horizontal,invert*vertical,0);
		
		transform.position += direction * movementSpeed * Time.deltaTime;
		
		float rotationHorizon = 0.0f;
		float rotationVertical = 0.0f;
		float rotationStep = 0.0f;
		
		//Debug.Log("LocalRotaion " + transform.localRotation.eulerAngles);
		
		if(horizontal != 0.0f) {
			if(horizontal > 0.0f) {
				// Right
				rotationHorizon =  maxRotationHorizon * horizontal;
			} else if (horizontal < 0.0f) {
				// Left
				rotationHorizon =  maxRotationHorizon * horizontal;
			}
			rotationStep = rotationSpeed * Time.deltaTime;
			
		} else if (horizontal == 0.0f ) {
			rotationStep = returnRotationSpeed * Time.deltaTime;
		}
		
		if(vertical != 0.0f) {
			if(invert * vertical > 0.0f) {
				rotationVertical =  maxRotationVertical * vertical * invert * (-1.0f);
			} else if (invert * vertical < 0.0f) {
				rotationVertical =  maxRotationVertical * vertical * invert * (-1.0f);
			}
			rotationStep = rotationSpeed * Time.deltaTime;
			
		} else if (vertical == 0.0f) {
			rotationStep = returnRotationSpeed * Time.deltaTime;
		}		
		
		Vector3 newRotation = new Vector3(rotationVertical, rotationHorizon, 0);
		//Debug.Log("NEW ROTATION" + newRotation);
		transform.localRotation =  Quaternion.Lerp(transform.localRotation, Quaternion.Euler(newRotation), rotationStep);
	}
	
	

}
