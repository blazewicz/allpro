/**
 * See the file LICENSE for redistribution information.
 *
 * Copyright (c) 2009-2016 ObdDiag.Net. All rights reserved.
 *
 */

#ifndef __PROTOCOL_ADAPTER_H__
#define __PROTOCOL_ADAPTER_H__

#include <adaptertypes.h>
#include <ecumsg.h>

// Command results
//
enum ReplyTypes {
    REPLY_OK =  1,
    REPLY_CMD_WRONG,
    REPLY_DATA_ERROR,
    REPLY_NO_DATA,
    REPLY_ERROR,
    REPLY_UNBL_2_CNNCT,
    REPLY_NONE,
    REPLY_BUS_BUSY,
    REPLY_BUS_ERROR,
    REPLY_CHKS_ERROR,
    REPLY_WIRING_ERROR
};

// Protocols
//
enum ProtocolTypes {
   PROT_AUTO = 0,
   PROT_J1850_PWM = 1,
   PROT_J1850_VPW = 2,
   PROT_ISO9141 = 3,
   PROT_ISO14230_5BPS = 4,
   PROT_ISO14230 = 5,
   PROT_ISO15765_1150 = 6,
   PROT_ISO15765_2950 = 7,
   PROT_ISO15765_1125 = 8,
   PROT_ISO15765_2925 = 9,
   PROT_J1939 = 0x0A,
   PROT_ISO15765_USR_B = 0x0B
};

// Adapters
//
enum AdapterTypes {
   ADPTR_AUTO = 1,
   ADPTR_PWM,
   ADPTR_VPW,
   ADPTR_ISO,
   ADPTR_CAN,
   ADPTR_CAN_EXT,
   ADPTR_J1939
};

class ProtocolAdapter {
public:
    static ProtocolAdapter* getAdapter(int adapterType);
    virtual int onConnectEcu(bool sendReply) = 0;
    virtual int onRequest(const uint8_t* data, uint32_t len, uint32_t numOfResp) = 0;
    virtual void getDescription() = 0;
    virtual void getDescriptionNum() = 0;
    virtual void dumpBuffer();
    virtual void setProtocol(int protocol) { connected_ = true; }
    virtual void open() { connected_ = false; }
    virtual void close();
    virtual void wiringCheck() = 0;
    virtual void sendHeartBeat() {}
    virtual int getProtocol() const = 0;
    virtual void kwDisplay() {}
    virtual void setFilterAndMask() {}
    bool isConnected() const { return connected_; }
    virtual void monitor() {}
    virtual void monitor(const uint8_t* data, uint32_t len, uint32_t numOfResp) {}
    void setStatus(int sts) { sts_ = sts; }
    int getStatus() const { return sts_; }
    static void clearHistory();
protected:
    static void insertToHistory(const Ecumsg* msg);
    static void appendToHistory(const Ecumsg* msg);
    ProtocolAdapter();
    bool           connected_;
    AdapterConfig* config_;
    int            sts_;
private:
    const static size_t HISTORY_LEN = 256;
    const static size_t ITEM_LEN    = 16;
    static size_t historyPos_;
    static uint8_t history_[HISTORY_LEN];
};

#endif //__PROTOCOL_ADAPTER_H__
