#include <iostream>
#include <fstream>
#include <cstring>
#include <list>
#include <json/json.h>
using namespace std;
#define ULL_MAX 0xFFFFFFFFFFFFFFFF

bool readFileJson(string tk,const char *pcFileName) {
	Json::Reader reader;
	Json::Value root;

	ifstream in(pcFileName, ios::binary);

	if (!in.is_open()) {
		cerr << "[ERROR] Error opening file!" << endl;
		return false;
	}

	if (reader.parse(in, root)) {
		string token = root["network"]["Token"].asString();
		if (tk == token)
			return true;
		const char *pctk = tk.c_str();
		char *sstr;
		uint64_t ullT = strtoull(tk.c_str(), &sstr, 10);
		if (ullT != ULL_MAX)
			root["network"]["Token"] = Json::Value(ullT);
		else {
			cerr << "[ERROR] Token too big for uint64_t! Writing 18446744073709551615!" << endl;
			return true;
		}

	} else
		cerr << "[ERROR] Parse error!" << endl;
	in.close();
	Json::StyledWriter sw;

	ofstream os(pcFileName, ios::out);
	if (!os.is_open()) {
		cerr << "[ERROR] Error opening file!" << endl;
		return false;
	}
	os << sw.write(root);
	os.close();
    cout << "[INFO] Value changed!" << endl;
	return false;
}
int main(int argc, char **argv) {
	if (argc == 3) {
		if (readFileJson(argv[1],argv[2]))
			cout << "[INFO] Value correct, no changes made!" << endl;
		return 0;
	}
    cerr<<"[ERROR] Invalid arguments!"<<endl;
	return 1;
}