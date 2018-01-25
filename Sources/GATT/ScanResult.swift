//
//  ScanResult.swift
//  GATT
//
//  Created by Alsey Coleman Miller on 1/6/18.
//  Copyright © 2018 PureSwift. All rights reserved.
//

import Foundation
import Bluetooth

public extension CentralManager {
    
    public struct ScanResult {
        
        /// Timestamp for when device was scanned.
        public let date: Date
        
        /// The discovered peripheral.
        public let peripheral: Peripheral
        
        /// The current received signal strength indicator (RSSI) of the peripheral, in decibels.
        public let rssi: Double
        
        /// Advertisement data.
        public let advertisementData: AdvertisementData
    }
}

public extension CentralManager.ScanResult {
    
    public struct AdvertisementData {
        
        /// The local name of a peripheral.
        public let localName: String?
        
        /// The Manufacturer data of a peripheral.
        public let manufacturerData: Data?
        
        /// Service-specific advertisement data.
        public let serviceData: [BluetoothUUID: Data]?
        
        /// An array of service UUIDs
        public let serviceUUIDs: [BluetoothUUID]?
        
        /// An array of one or more `BluetoothUUID`, representing Service UUIDs that were found
        /// in the “overflow” area of the advertisement data.
        public let overflowServiceUUIDs: [BluetoothUUID]?
        
        /// This value is available if the broadcaster (peripheral) provides its Tx power level in its advertising packet.
        /// Using the RSSI value and the Tx power level, it is possible to calculate path loss.
        public let txPowerLevel: Double?
        
        /// A Boolean value that indicates whether the advertising event type is connectable.
        public let isConnectable: Bool?
        
        /// An array of one or more `BluetoothUUID`, representing Service UUIDs.
        public let solicitedServiceUUIDs: [BluetoothUUID]?
    }
}

#if os(macOS) || os(iOS) || os(watchOS) || os(tvOS)
    
import Foundation
import CoreBluetooth

internal extension CentralManager.ScanResult.AdvertisementData {
    
    init(_ coreBluetooth: [String: Any]) {
        
        self.localName = coreBluetooth[CBAdvertisementDataLocalNameKey] as? String
        
        self.manufacturerData = coreBluetooth[CBAdvertisementDataManufacturerDataKey] as? Data
        
        if let coreBluetoothServiceData = coreBluetooth[CBAdvertisementDataServiceDataKey] as? [CBUUID: Data] {
            
            var serviceData = [BluetoothUUID: Data](minimumCapacity: coreBluetoothServiceData.count)
            
            for (key, value) in coreBluetoothServiceData {
                
                let uuid = BluetoothUUID(coreBluetooth: key)
                
                serviceData[uuid] = value
            }
            
            self.serviceData = serviceData
            
        } else {
            
            self.serviceData = nil
        }
        
        self.serviceUUIDs = (coreBluetooth[CBAdvertisementDataServiceUUIDsKey] as? [CBUUID])?.map { BluetoothUUID(coreBluetooth: $0) }
        
        self.overflowServiceUUIDs = (coreBluetooth[CBAdvertisementDataOverflowServiceUUIDsKey] as? [CBUUID])?.map { BluetoothUUID(coreBluetooth: $0) }
        
        self.txPowerLevel = (coreBluetooth[CBAdvertisementDataTxPowerLevelKey] as? NSNumber)?.doubleValue
        
        self.isConnectable = (coreBluetooth[CBAdvertisementDataIsConnectable] as? NSNumber)?.boolValue
        
        self.solicitedServiceUUIDs = (coreBluetooth[CBAdvertisementDataSolicitedServiceUUIDsKey] as? [CBUUID])?.map { BluetoothUUID(coreBluetooth: $0) }
    }
}

#endif