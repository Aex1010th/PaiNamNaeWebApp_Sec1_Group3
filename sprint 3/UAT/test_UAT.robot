*** Settings ***
Library    		  SeleniumLibrary

*** Variables ***
${homepage}    http://www.google.com
${browser}     Edge
${pnnUrl}      https://csse1369.cpkku.com/

${adminUser}			   admin123
${adminPass}			   123456789
${adminName}   			   System

${driverUser}			   driver123
${driverPass}              driver987654321
${driverName}			   driver

${passengerUser}		   passenger123
${passengerPass}           passenger1234
${passengerName}           passenger

${picture_evidence}		   ${CURDIR}/testdata/picture_evidence.jpg
${vdo_evidence}			   ${CURDIR}/testdata/vdo_evidence.mp4
${sound_evidence}		   ${CURDIR}/testdata/sound_evidence.mp3
${range}				   6

*** Test Cases ***
Create Route by Driver:
	[Documentation]    สร้างเส้นทางการเดินทางโดยผู้ขับขี่
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Create Route page
	Create Route
	Close Browser

Request Route by Passenger:
	[Documentation]    ขอจองที่นั่งสำหรับการเดินทาง
	Open PNN website
	
	Login as Passenger
	Go to Home page as passenger
	FOR    ${i}    IN RANGE    ${range}
		Go to Find Route page
		Request Top Route
	END
	Close Browser

Accept Request from Passenger by Driver:
	[Documentation]    ยืนยันคำขอจองที่นั่งของผู้โดยสารโดยผู้ขับขี่
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	FOR    ${i}    IN RANGE    ${range}
		Go to Request Trip
		Accept Passenger Request
	END
	Close Browser

Report Without Evidence:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่ไม่ได้มีการอัปโหลดไฟล์ใดๆ
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Without Upload File
	Close Browser
	
Report With Picture Evidence:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการอัปโหลดไฟล์รูปภาพอย่างเดียว
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Upload Picture
	Close Browser
	
Report With VDO Evidence:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการอัปโหลดไฟล์วิดีโออย่างเดียว
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Upload VDO
	Close Browser
	
Report With Sound Evidence:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการอัปโหลดไฟล์เสียงอย่างเดียว
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Upload Sound
	Close Browser	
	
Report With All types of Evidence:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการอัปโหลดไฟล์ทุกประเภทพร้อมๆกัน
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Upload All Evidence
	Close Browser
	
Report With Application Problem:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ System Report และประเภทปัญหา แอปพลิเคชันขัดข้อง
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Application Problem
	Close Browser
	
Report With Map Problem:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ System Report และประเภทปัญหา แผนที่ขัดข้อง
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Map Problem
	Close Browser
	
Report With System Slow:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ System Report และประเภทปัญหา ระบบทำงานล่าช้า
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	System Slow
	Close Browser
	
Report With System Problem Other:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ System Report และประเภทปัญหา อื่นๆ
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	System Problem Other
	Close Browser
	
Report With Accident:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ Trip Report และประเภทปัญหา อุบัติเหตุ
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Accident
	Close Browser
	
Report With Passenger Behavior:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ System Report และประเภทปัญหา พฤติกรรมผู้โดยสาร
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Passenger Behavior
	Close Browser
	
Report With Trip Problem Other:
	[Documentation]    ทำการรายงานปัญหาของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่มีการเลือกหมวดหมู่ System Report และประเภทปัญหา อื่นๆ
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Trip Problem Other
	Close Browser

Report Without Title:
	[Documentation]    ทำการรายงานปัญหาไม่สำเร็จของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่ไม่ได้กรอกหัวข้อปัญหา
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Without Title
	Close Browser
	
Report Without Description:
	[Documentation]    ทำการรายงานปัญหาไม่สำเร็จของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่ไม่ได้กรอกหัวข้อปัญหา
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Without Description
	Close Browser
	
Report Without System Category:
	[Documentation]    ทำการรายงานปัญหาไม่สำเร็จของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่ไม่ได้กดเลือกประเภทในหมวดหมู่ System Report
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Without System Category
	Close Browser
	
Report Without Trip Category:
	[Documentation]    ทำการรายงานปัญหาไม่สำเร็จของ driver จากการรายงานระหว่างการเดินทาง โดยเป็นการรายงานปัญหาที่ไม่ได้กดเลือกประเภทในหมวดหมู่ Trip Report
	Open PNN website
	
	Login as Driver
	Go to Home page as driver
	Go to Request Trip
	Go to ReportForm
	Without Trip Category
	Close Browser
	
Update Status In_Progress Without Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น In Progress และไม่มี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status In Progress no Comment
	Close Browser
	
Update Status Resolved Without Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น Resolved และไม่มี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status Resolved no Comment
	Close Browser
	
Update Status Rejected Without Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น Rejected และไม่มี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status Rejected no Comment
	Close Browser
	
Update Status In_Progress with Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น In Progress และมี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status In Progress and Comment
	Close Browser
	
Update Status Resolved with Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น Resolved และมี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status Resolved and Comment
	Close Browser
	
Update Status Rejected with Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น Rejected และมี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status Rejected and Comment
	Close Browser
	
Update Status Resolved by hotkey with Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น Resolved ด้วยปุ่มลัด และมี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status Resolved by hotkey and Comment
	Close Browser
	
Update Status Rejected by hotkey with Comment:
	[Documentation]    ทำการอัปเดตสถานะของรายงานโดย admin เป็น Rejected ด้วยปุ่มลัด และมี Comment ตอบกลับ
	Open PNN website
	
	Login as Admin
	Go to Home page as admin
	Go to Dashboard page
	Go to Incident Management page
	Update Status Rejected by hotkey and Comment
	Close Browser
	
Driver View All Report:
	[Documentation]    driver ทำการตรวจสอบประวัติรายงานปัญหาที่ได้รายงานไป
	Open PNN website
	
	Login as Driver
	Go to Profile page
	View All Report
	Close Browser

End Route by Driver:
	[Documentation]    driver ทำการจบการเดินทาง
	Open PNN website
	
	Login as Driver
	Go to Request Trip
	Start Route and End Route
	Close Browser

Review Only Star by Passenger:
	[Documentation]    passenger ทำการรีวิวโดยให้แค่ดาว
	Open PNN website
	
	Login as Passenger
	Go to Complete Trip
	Review Only Star
	Close Browser
	
Review Star with Description by Passenger:
	[Documentation]    passenger ทำการรีวิวโดยให้ดาวกับเขียนคำอธิบาย
	Open PNN website
	
	Login as Passenger
	Go to Complete Trip
	Review Star with Description
	Close Browser
	
Review Star with Tag by Passenger:
	[Documentation]    passenger ทำการรีวิวโดยให้ดาวกับ tag
	Open PNN website
	
	Login as Passenger
	Go to Complete Trip
	Review Star with Tag
	Close Browser
	
Review Star with File by Passenger:
	[Documentation]    passenger ทำการรีวิวโดยให้ดาวกับอัปโหลดไฟล์
	Open PNN website
	
	Login as Passenger
	Go to Complete Trip
	Review Star with File
	Close Browser
	
Review All by Passenger:
	[Documentation]    passenger ทำการรีวิวโดยใส่รายละเอียดต่างๆทั้งหมด
	Open PNN website
	
	Login as Passenger
	Go to Complete Trip
	Review All
	Close Browser
	
*** Keywords ***
Open PNN website
    Open Browser    ${homepage}    ${browser}
	Maximize Browser Window
    Go To    ${pnnUrl}
	
Login as Driver
	Sleep    2s
	Wait Until Page Contains    เดินทางร่วมกัน อย่างมั่นใจ ด้วยความปลอดภัยเป็นอันดับหนึ่ง    timeout=10s
	Click Element    xpath=//a[normalize-space()="เข้าสู่ระบบ"]
	Sleep    2s
	Input Text    id=identifier       	${driverUser}
	Input Text    id=password    		${driverPass}
	Click Button    xpath=//button[normalize-space()="เข้าสู่ระบบ"]
	
Login as Passenger
	Sleep    2s
	Wait Until Page Contains    เดินทางร่วมกัน อย่างมั่นใจ ด้วยความปลอดภัยเป็นอันดับหนึ่ง    timeout=10s
	Click Element    xpath=//a[normalize-space()="เข้าสู่ระบบ"]
	Input Text    id=identifier       	${passengerUser}
	Input Text    id=password    		${passengerPass}
	Click Button    xpath=//button[normalize-space()="เข้าสู่ระบบ"]
	
Login as Admin
	Sleep    2s
	Wait Until Page Contains    เดินทางร่วมกัน อย่างมั่นใจ ด้วยความปลอดภัยเป็นอันดับหนึ่ง    timeout=10s
	Click Element    xpath=//a[normalize-space()="เข้าสู่ระบบ"]
	Input Text    id=identifier       	${adminUser}
	Input Text    id=password    		${adminPass}
	Click Button    xpath=//button[normalize-space()="เข้าสู่ระบบ"]
	
Go to Home page as driver
	Sleep    2s
	Wait Until Page Contains    เดินทางร่วมกัน อย่างมั่นใจ ด้วยความปลอดภัยเป็นอันดับหนึ่ง    timeout=10s
	Wait Until Page Contains    ${driverName}    timeout=10s
	
Go to Home page as passenger
	Sleep    2s
	Wait Until Page Contains    เดินทางร่วมกัน อย่างมั่นใจ ด้วยความปลอดภัยเป็นอันดับหนึ่ง    timeout=10s
	Wait Until Page Contains    ${passengerName}    timeout=10s
	
Go to Home page as admin
	Sleep    2s
	Wait Until Page Contains    เดินทางร่วมกัน อย่างมั่นใจ ด้วยความปลอดภัยเป็นอันดับหนึ่ง    timeout=10s
	Wait Until Page Contains    ${adminName}     timeout=10s
	
Go to Dashboard page
	Sleep    2s
	#เคอร์เซอร์เมาส์ไปชี้ที่่ Profile
	Mouse Over    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[4]/div[1]
	  #กดปุ่ม Dashboard
	  Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[4]/div[2]/a[2]
	Wait Until Page Contains    User Management   timeout=10s
	
Go to Incident Management page
	Sleep    2s
	Click Element    xpath=//*[@id="sidebar"]/div/nav/a[6]
	Wait Until Page Contains    Incident Management   timeout=10s
	
Go to Profile page
	Sleep    2s
	#เคอร์เซอร์เมาส์ไปชี้ที่่ Profile
	Mouse Over    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[4]/div[1]
	  #กดปุ่ม บัญชีของฉัน
	  Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[4]/div[2]/a[1]
	Wait Until Page Contains    โปรไฟล์ของฉัน   timeout=10s
	
Go to Request Trip
	Sleep    2s
	#เคอร์เซอร์เมาส์ไปชี้ที่่ "การเดินทางทั้งหมด"
	Mouse Over    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[2]/div/a
	  #กดปุ่ม "คำขอจองเส้นทางทั้งหมดของฉัน"
	  Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[2]/div/div/a[2]
	Wait Until Page Contains    คำขอจองเส้นทางของฉัน    timeout=10s
	
Go to Complete Trip
	Sleep    2s
	#กดปุ่ม "การเดินทางของฉัน"
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/div[2]/a
	Wait Until Page Contains    การเดินทางของฉัน    timeout=10s
	#กดปุ่มเสร็จสิ้นแล้ว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div/button[5]
	Wait Until Page Contains    เสร็จสิ้นแล้ว    timeout=10s

Go to ReportForm
	Sleep    2s
	#กดปุ่ม ยืนยันแล้ว ของการจองเส้นทาง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div/button[2]
	Wait Until Page Contains    ยืนยันแล้ว    timeout=10s
	#กดปุ่ม ธง เพื่อรายงานปัญหา
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[1]/div[2]/div[1]/div[1]/a
	
Go to Create Route page
	Sleep    2s
	Click Element    xpath=//a[@href='/createTrip']
	Wait Until Page Contains    สร้างการเดินทางของคุณ    timeout=10s
	
Go to Find Route page
	Sleep    5s
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/header/div/div[1]/nav/a
	Wait Until Page Contains    ค้นหาการเดินทาง    timeout=10s
	
Create Route
	Sleep    2s
	#ใส่จุดเริ่มต้น
	Input Text    xpath=//*[@id="startPoint"]    ขอนแก่น
	Wait Until Element Is Visible    xpath=(//div[contains(@class,'pac-item')])[1]    10s
	Click Element    xpath=(//div[contains(@class,'pac-item')])[1]
	#ใส่จุดปลายทาง
	Input Text    xpath=//*[@id="endPoint"]    กรุงเทพ
	Wait Until Element Is Visible    xpath=(//div[contains(@class,'pac-item')])[1]    10s
	Click Element    xpath=(//div[contains(@class,'pac-item')])[1]
	#ใส่วันที่เดินทาง
	Input Text    xpath=//*[@id="travelDate"]    01012027
	#ใส่เวลาออกเดินทาง
	Input Text    xpath=//*[@id="travelTime"]    0900AM
	#ใส่จำนวนที่นั่งที่รับได้
	Input Text    xpath=//*[@id="seatCount"]    7
	#ใส่ราคาต่อที่นั่ง
	Input Text    xpath=//*[@id="pricePerSeat"]    100
	#กดปุ่มสร้างเส้นทาง
	Scroll Element Into View    xpath=//button[@type='submit']
	Click Element    xpath=//button[@type='submit']
	Wait Until Page Contains    Route created successfully    timeout=10s
	
Request Top Route
	Sleep    2s
	#กดเลือกทริปบนสุด
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div[1]/div/div[2]/div[1]
	#กดจองที่นั่ง
	Wait Until Element Is Visible    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div[1]/div/div[2]/div[1]/div[2]/div[3]/button    timeout=10s
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div[1]/div/div[2]/div[1]/div[2]/div[3]/button
	#ใส่จุดขึ้นรถ
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/div[4]/div[2]/div/input    ขอนแก่น
	Wait Until Element Is Visible    xpath=(//div[contains(@class,'pac-item')])[1]    10s
	Click Element    xpath=(//div[contains(@class,'pac-item')])[1]
	#ใส่จุดลงรถ
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/div[4]/div[3]/div/input    กรุงเทพ
	Wait Until Element Is Visible    xpath=(//div[contains(@class,'pac-item')])[1]    10s
	Click Element    xpath=(//div[contains(@class,'pac-item')])[1]
	#กดยืนยันการจอง
	Scroll Element Into View    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/div[6]/button[2]
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/div[6]/button[2]
	
Accept Passenger Request
	Sleep    2s
	#กดปุ่มยืนยันคำขอ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div/div[3]/button[1]
	Wait Until Page Contains    ยืนยันคำขอจอง    timeout=10s
	#กดปุ่มยืนยันคำขออีกครั้ง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/button[2]
	Wait Until Page Contains    ยืนยันคำขอแล้ว    timeout=10s
	
Without Upload File
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยไม่แนบหลักฐานใดๆ
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหา โดยไม่แนบหลักฐานใดๆไปกับรายงาน
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Upload Picture
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยแนบหลักฐานเพียงรูปภาพ
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหา โดยแนบหลักฐานเพียงรูปภาพไฟล์เดียว
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#อัปโหลดหลักฐานรูปภาพ
	Choose File    xpath=//input[@type='file']    ${picture_evidence}
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Upload VDO
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยแนบหลักฐานเพียงคลิปวิดีโอ
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหา โดยแนบหลักฐานเพียงคลิปวิดีโอไฟล์เดียว
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#อัปโหลดหลักฐานวิดีโอ
	Choose File    xpath=//input[@type='file']    ${vdo_evidence}
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Upload Sound
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยแนบหลักฐานเพียงคลิปเสียง
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหา โดยแนบหลักฐานเพียงคลิปเสียงไฟล์เดียว
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#อัปโหลดหลักฐานคลิปเสียง
	Choose File    xpath=//input[@type='file']    ${sound_evidence}
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Upload All Evidence
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยแนบหลักฐานทุกประเภท
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยแนบหลักฐานทั้งรูปภาพ คลิปวิดีโอ คลิปเสียง
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#อัปโหลดหลักฐานทั้งสามประเภท
	Choose File    xpath=//input[@type='file']    ${picture_evidence}\n${vdo_evidence}\n${sound_evidence}
	Sleep    2s
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Application Problem
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ system และ ประเภท แอพขัดข้อง
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "System Report" และเลือกประเภท "แอปพลิเคชันขัดข้อง"
	#กดปุ่ม System Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[1]
	#กดเลือกประเภทปัญหาเป็น แอปพลิเคชันขัดข้อง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[1]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Map Problem
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ system และ ประเภท แผนที่ขัดข้อง
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "System Report" และเลือกประเภท "แผนที่ขัดข้อง"
	#กดปุ่ม System Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[1]
	#กดเลือกประเภทปัญหาเป็น แผนที่ขัดข้อง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[2]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
System Slow
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ system และ ประเภท ระบบช้า
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "System Report" และเลือกประเภท "ระบบทำงานล่าช้า"
	#กดปุ่ม System Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[1]
	#กดเลือกประเภทปัญหาเป็น ระบบทำงานล่าช้า
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
System Problem Other
	Sleep   2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ system และ ประเภท อื่นๆ
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "System Report" และเลือกประเภท "อื่นๆ"
	#กดปุ่ม System Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[1]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[4]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Accident
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ trip และ ประเภท อุบัติเหตุ
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "Trip Report" และเลือกประเภท "อุบัติเหตุ"
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อุบัติเหตุ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[1]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s
	
Passenger Behavior
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ trip และ ประเภท พฤติกรรมผู้โดยสาร
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "Trip Report" และเลือกประเภท "พฤติกรรมผู้โดยสาร"
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น พฤติกรรมผู้โดยสาร
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[2]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s	
	
Trip Problem Other
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานได้ โดยเลือกหมวดหมู่ trip และ ประเภท อื่นๆ
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "Trip Report" และเลือกประเภท "อื่นๆ"
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    ส่งรายงานสำเร็จ    timeout=10s	
	
Without Title
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาไม่สำเร็จ เพราะไม่ใส่หัวข้อปัญหา
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    กรอกข้อมูลไม่ครบ    timeout=10s
	
Without Description
	Sleep    5s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานไม่สำเร็จ เพราะไม่ใส่คำอธิบายเพิ่มเติม
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดเลือกประเภทปัญหาเป็น อื่นๆ
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[5]/div/button[3]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    กรอกข้อมูลไม่ครบ    timeout=10s
	
Without System Category
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานไม่ได้ โดยไม่เลือกประเภทในหมวดหมู่ System
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาไม่สำเร็จ โดยกดเลือกหมวดหมู่ "System Report" แต่ไม่เลือกประเภท
	#กดปุ่ม System Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[1]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    กรอกข้อมูลไม่ครบ    timeout=10s
	
Without Trip Category
	Sleep    2s
	Wait Until Page Contains    รายงานปัญหา    timeout=10s
	#กรอกข้อมูลใน หัวข้อปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/input    ส่งรายงานไม่ได้ โดยไม่เลือกประเภทในหมวดหมู่ Trip
	#กรอกข้อมูลใน อธิบายปัญหา
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/textarea    ส่งรายงานปัญหาโดยกดเลือกหมวดหมู่ "Trip Report" แต่ไม่เลือกประเภท
	#กดปุ่ม Trip Report
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[4]/div/button[2]
	#กดปุ่ม ส่งรายงาน
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[7]/button[2]
	Wait Until Page Contains    กรอกข้อมูลไม่ครบ    timeout=10s
	
Update Status In Progress no Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กดเลือกอัปเดตสถานะของ Report เป็น In Progress
	Select From List By Label    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[1]/select    In Progress
	#กดปุ่ม save
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[3]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น In Progress
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    In Progress
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status Resolved no Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กดเลือกอัปเดตสถานะของ Report เป็น Resolved
	Select From List By Label    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[1]/select    Resolved
	#กดปุ่ม save	
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[3]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น Resolved
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    Resolved
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status Rejected no Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กดเลือกอัปเดตสถานะของ Report เป็น Rejected
	Select From List By Label    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[1]/select    Rejected
	#กดปุ่ม save	
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[3]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น Rejected
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    Rejected
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status In Progress and Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กดเลือกอัปเดตสถานะของ Report เป็น In Progress
	Select From List By Label    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[1]/select    In Progress
	#กรอกข้อมูลเพื่ออธิบายเหตุผลต่างๆ
	Input Text    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/textarea    กำลังดำเนินการแก้ไขปัญหาที่แจ้งมา
	#กดปุ่ม save	
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[3]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น In Progress
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    In Progress
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status Resolved and Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กดเลือกอัปเดตสถานะของ Report เป็น Resolved
	Select From List By Label    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[1]/select    Resolved
	#กรอกข้อมูลเพื่ออธิบายเหตุผลต่างๆ
	Input Text    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/textarea    แก้ไขปัญหาที่แจ้งมาเรียบร้อยแล้ว
	#กดปุ่ม save	
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[3]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น Resolved
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    Resolved
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status Rejected and Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กดเลือกอัปเดตสถานะของ Report เป็น Rejected
	Select From List By Label    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[1]/select    Rejected
	#กรอกข้อมูลเพื่ออธิบายเหตุผลต่างๆ
	Input Text    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/textarea    ปฏิเสธการแก้ไขปัญหาที่แจ้งมา
	#กดปุ่ม save	
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[3]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น Rejected
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    Rejected
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status Resolved by hotkey and Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กรอกข้อมูลเพื่ออธิบายเหตุผลต่างๆ
	Input Text    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/textarea    แก้ไขปัญหาที่แจ้งมาเรียบร้อยแล้ว
	#กดปุ่ม Mark as Resolved
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[2]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น Resolved
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    Resolved
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
Update Status Rejected by hotkey and Comment
	Sleep    2s
	#กดเลือกหมวดหมู่ Received
	Click Button    xpath=//*[@id="main-content"]/div[3]/div/button[2]
	#กดเลือก Report แรกสุด
	Click Element    xpath=//*[@id="main-content"]/div[4]/div[1]/table/tbody/tr[1]
	Wait Until Page Contains    Incident Details    timeout=10s
	#กรอกข้อมูลเพื่ออธิบายเหตุผลต่างๆ
	Input Text    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/textarea    ปฏิเสธการแก้ไขปัญหาที่แจ้งมา
	Sleep    5s
	#กดปุ่ม Rejected
	Click Button    xpath=//*[@id="main-content"]/div[2]/div[1]/div[2]/div/div[2]/div/button[1]
	Sleep    1s
	#ตรวจสอบว่า Status เปลี่ยนเป็น Rejected
	Element Text Should Be    xpath=//*[@id="main-content"]/div[2]/div[1]/div[1]/div/div[2]/span    Rejected
	Wait Until Page Contains    ✅ Updated successfully    timeout=10s
	
View All Report
	Sleep    2s
	#กดปุ่ม ประวัติการรายงานปัญหา
	Click Element    xpath=//a[normalize-space()='ประวัติการรายงานปัญหา']
	Wait Until Page Contains    ประวัติการรายงานปัญหา    timeout=10s
	Sleep    2s
	#กดดูรายงานฉบับล่าสุดที่รายงาน
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/main/div[3]/a[1]
	Sleep    1s
	Wait Until Page Contains    รายการปัญหาที่คุณรายงาน    timeout=10s
	
Start Route and End Route
	Sleep    2s
	#กดปุ่ม ยืนยันแล้ว ของการจองเส้นทาง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div/button[2]
	Wait Until Page Contains    ยืนยันแล้ว    timeout=10s
	#กดปุ่มเริ่มการเดินทาง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[1]/div[3]/button
	Wait Until Page Contains    เริ่มการเดินทาง    timeout=10s
	#กดปุ่มเริ่มเดินทาง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/button[2]
	Wait Until Page Contains    เริ่มการเดินทางแล้ว    timeout=10s
	#กดปุ่ม กำลังเดินทาง ของการจองเส้นทาง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[2]/div/button[3]
	Wait Until Page Contains    รายการที่กำลังเดินทาง    timeout=10s
	#กดปุ่มจบการเดินทาง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div/div[3]/button
	Wait Until Page Contains    จบการเดินทาง    timeout=10s
	#กดปุ่มจบการเดินทางอีกครั้ง
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div[2]/div/div[2]/button[2]
	Wait Until Page Contains    จบการเดินทางแล้ว    timeout=10s
	
Review Only Star
	Sleep    2s
	#กดปุ่มรีวิว
	Scroll Element Into View    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[1]/div[3]/a
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[1]/div[3]/a
	#กดดาว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[2]/div/button[2]
	#กดส่งรีวิว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[6]/button
	Wait Until Page Contains    ขอบคุณสำหรับรีวิว!    timeout=10s
	
Review Star with Description
	Sleep    2s
	#กดปุ่มรีวิว
	Scroll Element Into View    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[2]/div[3]/a
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[2]/div[3]/a
	#กดดาว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[2]/div/button[3]
	#ใส่คำอธิบาย
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[3]/textarea    ปานกลาง 3 ดาวนะ
	#กดส่งรีวิว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[6]/button
	Wait Until Page Contains    ขอบคุณสำหรับรีวิว!    timeout=10s
	
Review Star with Tag
	Sleep    2s
	#กดปุ่มรีวิว
	Scroll Element Into View    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[3]/div[3]/a
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[3]/div[3]/a
	#กดดาว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[2]/div/button[5]
	#เพิ่ม tag
	Wait Until Element Is Not Visible    xpath=//*[contains(.,'เลือกคะแนนก่อนเพื่อดูแท็กที่เกี่ยวข้อง')]    10s
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[4]/div/button[1]
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[4]/div/button[3]
	#กดส่งรีวิว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[6]/button
	Wait Until Page Contains    ขอบคุณสำหรับรีวิว!    timeout=10s
	
Review Star with File
	Sleep    2s
	#กดปุ่มรีวิว
	Scroll Element Into View    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[4]/div[3]/a
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[4]/div[3]/a
	#กดดาว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[2]/div/button[1]
	#อัปโหลดไฟล์
	Choose File    xpath=//input[@type='file']    ${picture_evidence}\n${vdo_evidence}\n${sound_evidence}
	#กดส่งรีวิว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[6]/button
	Wait Until Page Contains    ขอบคุณสำหรับรีวิว!    timeout=10s
	
Review All
	Sleep    2s
	#กดปุ่มรีวิว
	Scroll Element Into View    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[5]/div[3]/a
	Click Element    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div[3]/div[1]/div/div[2]/div[5]/div[3]/a
	#กดดาว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[2]/div/button[4]
	#ใส่คำอธิบาย
	Input Text    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[3]/textarea    ค่อนข้างดีเลยนะ ให้ 4 ดาวไปเลย
	#เพิ่ม tag
	Wait Until Element Is Not Visible    xpath=//*[contains(.,'เลือกคะแนนก่อนเพื่อดูแท็กที่เกี่ยวข้อง')]    10s
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[4]/div/button[2]
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[4]/div/button[5]
	#อัปโหลดไฟล์
	Choose File    xpath=//input[@type='file']    ${picture_evidence}\n${vdo_evidence}\n${sound_evidence}
	#กดส่งรีวิว
	Click Button    xpath=//*[@id="__nuxt"]/div/div[1]/main/div/div/div/div[2]/div[6]/button
	Wait Until Page Contains    ขอบคุณสำหรับรีวิว!    timeout=20s