using UnityEngine;
using System.Collections;

public class ShipBank : MonoBehaviour {
	

	public float maxBankHorozin = 20.0f;
	public float maxBankRotation = 90.0f;
	
	public float horozinBankSpeed = 1.0f;
	public float returnHorozinBankSpeed = 1.0f;
	
	public float rotationBankSpeed  = 1.0f;
	public float returnRotationBankSpeed = 1.0f;
	
	public float doubleTapDelay = 0.2f;
	
	private float timeLeft = float.MaxValue;
	private float timeRight = float.MaxValue;
	private bool buttonLeftDown = false;
	private bool buttonRightDown = false;
	private bool inBarrelRoll = false;
	
	// Use this for initialization
	void Start () {
	
	}
	
	// Update is called once per frame
	void Update () {
		checkDoubleTap();
		shipBank();


	}
	
	void checkDoubleTap () {
		
		if(!inBarrelRoll) {
			float bankAxis = Input.GetAxis("Bank");
			
			//Debug.Log("BANK AXIX " + bankAxis);
		
			
			if(bankAxis == 0.0f) {
				if(buttonLeftDown == true) {
					timeLeft = 0.0f;
				}
				
				if(buttonRightDown == true) {
					timeRight = 0.0f;
				}
				
				buttonLeftDown = false;
				buttonRightDown = false;
			} else if (bankAxis > 0.0f) {
				// Right
				buttonRightDown = true;
				
				if(timeRight < doubleTapDelay) {
					buttonLeftDown = false;
					buttonRightDown = false;
					timeRight += doubleTapDelay * 4.0f;
					Debug.Log("BARREL RIGHT");
				}
			} else if (bankAxis < 0.0f) {
				// Left
				buttonLeftDown = true;
				if(timeLeft < doubleTapDelay) {
					buttonLeftDown = false;
					buttonRightDown = false;
					timeLeft += doubleTapDelay * 4.0f;
					Debug.Log("BARREL LEFT");
				}
			}
			
			
		}
		
		timeLeft += Time.deltaTime;
		timeRight += Time.deltaTime;
	}
	
	void shipBank () {
		float horizontal = Input.GetAxis("Horizontal");
		float bankAxis = Input.GetAxis("Bank");
		
	
		float bankRotation = 0.0f;
		
		float rotationStep = 0.0f;
		
		if(horizontal != 0.0f && bankAxis == 0.0f) {
			if(horizontal > 0.0f) {
				// Right
				bankRotation =  maxBankHorozin * horizontal * (-1.0f);
			} else if (horizontal < 0.0f) {
				// Left
				bankRotation =  maxBankHorozin * horizontal * (-1.0f);
			}
			rotationStep = horozinBankSpeed * Time.deltaTime;
			
		} else if (horizontal == 0.0f ) {
			rotationStep = returnHorozinBankSpeed * Time.deltaTime;
		}
		
		if(bankAxis != 0.0f) {
			if(bankAxis > 0.0f) {
				// Right
				bankRotation =  maxBankRotation * bankAxis * (-1.0f);
			} else if (bankAxis < 0.0f) {
				// Left
				bankRotation =  maxBankRotation * bankAxis * (-1.0f);
			}
			rotationStep = rotationBankSpeed * Time.deltaTime;
		}
		
		
		
		
		
		
		Vector3 newRotation = new Vector3(0, 0, bankRotation);
		//Debug.Log("HOROZONTAL " + horizontal);
		//Debug.Log("BANK ROTATION " + newRotation);
		//Debug.Log("STEP " + rotationStep);
		transform.localRotation =  Quaternion.Lerp(transform.localRotation, Quaternion.Euler(newRotation), rotationStep);
		
	}
}
