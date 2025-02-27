//*****************************************************************************
// File Name    : user_code.h
//
// Author  : Markus Joos (markus.joos@cern.ch)
//
//*****************************************************************************

//User code for the ALB

// This file is the header file for user code.
// Users of the MMC S/W should only have to modify this file as well as user_code.c

#ifndef USER_CODE_H
#define USER_CODE_H

#include <avr/io.h>
#include "../avrlibtypes.h"
#include "../avrlibdefs.h"
#include "../a2d.h"
#include "../led.h"
#include "../sdr.h"
#include "../i2csw.h"
#include "../ipmi_if.h"
#include "../eeprom.h"
#include "../fru.h"
#include "../timer.h"


//********************************
//Constants for the IPMI DEVICE ID   //See ipmi_get_device_id in ipmi_if.c
//********************************
// firmware release
#define MMC_FW_REL_MAJ       1                  // major release, 7 bit
#define MMC_FW_REL_MIN       0                  // minor release, 8 bit
// manufacturer specific identifier codes
// NOTE: Manufacturer identification is handled by http://www.iana.org/assignments/enterprise-numbers
#define IPMI_MSG_MANU_ID_LSB 0x60               //CERN IANA ID = 0x000060
#define IPMI_MSG_MANU_ID_B2  0x00
#define IPMI_MSG_MANU_ID_MSB 0x00
#define IPMI_MSG_PROD_ID_LSB 0x35
#define IPMI_MSG_PROD_ID_MSB 0x12
#define IO_EXPANDER_ADD      0x3A


//******************************
//Constants for the FRU / EEPROM
//******************************
#define SIZE_INFO           128  // size data for BOARD and PRODUCT Information


//**********************
//Constants for AMC LEDs
//**********************
#define NUM_OF_AMC_LED    3       //Note: the first 3 LEDs are mandatory //MJ: 3 mandatory, 8 user, 1 (LED3) not implemented


//The definitions below are for the IO expander at address "RTM_IO_PORTS_ADDR"
#define BLUE_LED_BIT      1
#define RED_LED_BIT       2
#define GREEN_LED_BIT     3


//*******************
// Constants for SDRs
//*******************

//Sensor numbers
//NOTE: First declare all AMC then all RTM sensors
//AMC sensors
#define HOT_SWAP_SENSOR     0
#define TEMPERATURE_SENSOR1 1
#define TEMPERATURE_SENSOR2 2
#define TEMPERATURE_SENSOR3 3
#define VOLT_12             4

#define NUM_SENSOR_AMC      5   //The device locators for AMC does not count
#define NUM_SDR_AMC         6

//As we don't have an RTM
#define NUM_SENSOR_RTM      0
#define NUM_OF_RTM_LED      0
#define NUM_SDR_RTM         0

// Sensor type codes
#define TEMPERATURE         0x01
#define VOLTAGE             0x02
#define HOT_SWAP            0xF2

// Pins for a DCDC. //MJ-VB: Check if this is OK
#define DCDC_ENABLE_PORT PORTC
#define DCDC_ENABLE_PIN  PC7
#define REG_ENABLE_PORT PORTC
#define REG_ENABLE_PIN  PC6


//*****************************
//Mandatory function prototypes
//*****************************
//NOTE: Users must not change the API of the functions listed below
void leds_init_user();
void local_led_control_user(u08 led_n, u08 led_state);
void led_control_user(u08 led_n, u08 led_state);
void rtm_led_control_user(u08 led, u08 onoff);
void init_port_user(void);
void sensor_init_user();
void sensor_monitoring_user();
void rtm_sensor_set_state_user(u08 state);
u08 state_led_user(u08 led_n);
u08 ipmi_get_led_color_capabilities_user(u08 fru, u08 LedId, u08 *buf);
u08 Board_information(u08 buf[]);
u08 Product_information(u08 buf[]);
u08 Multirecord_area_Module(u08 buf[]);
u08 Multirecord_area_Point_to_point(u08 buf[]);
u08 ipmi_picmg_fru_control(u08 control_type);
u08 user_ok_for_m4(void);


//********************************
//User defined function prototypes
//********************************
//NOTE: Users are free to change the API of the functions listed below or to add and delete functions
u08 tempSensorRead(u08 sensor);
void load_rtm_eeprom();

//Just for debugging purposes
void set_led_pattern(u08 bank, u08 pattern, u08 level);


#endif
