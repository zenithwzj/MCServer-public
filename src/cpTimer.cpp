#include <iostream>
#include <fstream>
#include <chrono>
#include <ctime>
#ifdef _WIN32
    #include <windows.h>
	#define CP_sleep(iMs) Sleep(iMs)
#else
    #include <unistd.h>
	#define CP_sleep(iMs) usleep(iMs * 1000)
#endif
#define minTimeout 3
using namespace std;
ofstream LOG;
string Ltm();
void killProc();

int main() {
	LOG.open("Ttimer.log");
	LOG << Ltm() << "Program start,Timeout in minutes:" << minTimeout - 2 << endl;
	auto t0 = chrono::high_resolution_clock::now();
	while (1) {
		auto t1 = chrono::high_resolution_clock::now();
		auto Dt = chrono::duration_cast<chrono::minutes>(t1 - t0).count();
		if (Dt >= (minTimeout - 2)) {
			LOG << Ltm() << "Killing process." << endl;
			LOG.close();
			killProc();
			LOG.open("Ttimer.log", ios_base::app);
			LOG << Ltm()<<"Program exiting."<<endl;
			LOG.close();
			return 0;
		}
		CP_sleep(1500);
	}
	return 1;
}
void killProc(){
	#ifdef _WIN32
		system("taskkill /IM openp2p.exe /F >> Ttimer.log 2>&1");
		system("taskkill /IM java.exe /F >> Ttimer.log 2>&1");
	#else
		system("pkill -ein --signal 15 openp2p >> Ttimer.log 2>&1");
		system("pkill -ein --signal 15 java >> Ttimer.log 2>&1");
	#endif
	return;
}
string Ltm() {
	#ifdef _WIN32
		SYSTEMTIME t;
		GetLocalTime(&t);
		char rt[23];
		sprintf(rt, "%04d/%02d/%02d %02d:%02d:%02d.%03d", t.wYear, t.wMonth, t.wDay, t.wHour, t.wMinute,
				t.wSecond,
				t.wMilliseconds);
		string srt(rt);
		return srt;
	#else
		time_t t; // t passed as argument in function time()
		struct tm * tt; // decalring variable for localtime()
		time (&t); //passing argument to time()
		tt = localtime(&t);
		char rt[30];//counted28+\n
		sprintf(rt,"%s\t",asctime(tt));
		string srt(rt);
		return srt;
	#endif
}