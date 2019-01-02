# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'bee_test_6.ui'
#
# Created by: PyQt5 UI code generator 5.11.3
#
# WARNING! All changes made in this file will be lost!

import csv
from PyQt5 import QtCore, QtGui, QtWidgets

class Test:
    tar_gene = []
    def __init__(self, test_name):
        tar_gene = []
        with open(test_name, "r", encoding='UTF-8', newline='') as source:
            source_reader = csv.DictReader(source, delimiter="\t")
            for row in source_reader:
                temp = (row['STRONGEST SNP-RISK ALLELE']).split("-")
                tar_gene.append((temp[0], temp[1]))
        self.tar_gene = tar_gene

class Analyze:
    process_rsid = ""
    result = ""

    def __init__(self, sample_name, tar_gene):
        process_rsid = ""
        result = ""
        num_matched = 0
        with open(sample_name, "r", encoding='UTF-8', newline='') as sample:
            sample_reader = csv.DictReader(sample, delimiter="\t")
            for row in sample_reader:
                rsid = row['# rsid']
                genotype = row["genotype"]
                for tar in tar_gene:
                    if tar[0] == rsid:
                        # print("rsid match")
                        process_rsid = process_rsid + rsid + "\n"
                        if len(genotype) == 2:
                            if tar[1] == genotype[0] or tar[1] == genotype[1]:
                                result = result + tar[0] + "-" + tar[1] + "\n"
                                num_matched = num_matched + 1
                        elif len(genotype) == 1:
                            if tar[1] == genotype[0]:
                                result = result + tar[0] + "-" + tar[1] + "\n"
                                num_matched = num_matched + 1
            result = result + "\n" + "matched data: " + str(num_matched) + "\n"
            self.process_rsid = process_rsid
            self.result = result
            # print("Done analyzing.")

    def get_process_rsid(self):
        return self.process_rsid

    def get_result(self):
        if len(self.result) == 0:
            # self.result.append("No matched data.")
            return self.result
        else:
            return self.result


sample_string = "Select a Sample"
test_string = "Select a Test"


def analyze_now():
    global sample_string, test_string

    if sample_string != "Select a Sample" and test_string != "Select a Test":
        temp_sample = sample_string + ".tsv"
        temp_test = test_string + ".tsv"
        data = Test(temp_test)
        result = Analyze(temp_sample, data.tar_gene)
        ui.textBrowser_process.setText(result.get_process_rsid())
        ui.textBrowser_matched.setText(result.get_result())


def get_sample_string(s):
    global sample_string
    sample_string = s


def get_test_string(s):
    global test_string
    test_string = s

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(760, 704)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.horizontalLayout_6 = QtWidgets.QHBoxLayout(self.centralwidget)
        self.horizontalLayout_6.setObjectName("horizontalLayout_6")
        self.gridLayout = QtWidgets.QGridLayout()
        self.gridLayout.setObjectName("gridLayout")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(14)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.gridLayout.addWidget(self.label_2, 3, 1, 1, 1)
        self.pushButton = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(16)
        self.pushButton.setFont(font)
        self.pushButton.setObjectName("pushButton")
        self.gridLayout.addWidget(self.pushButton, 2, 2, 1, 1)
        self.textBrowser_process = QtWidgets.QTextBrowser(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.textBrowser_process.setFont(font)
        self.textBrowser_process.setObjectName("textBrowser_process")
        self.gridLayout.addWidget(self.textBrowser_process, 4, 1, 1, 1)
        self.pushButton_export = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_export.setFont(font)
        self.pushButton_export.setObjectName("pushButton_export")
        self.gridLayout.addWidget(self.pushButton_export, 1, 2, 1, 1)
        self.pushButton_analyze = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(16)
        self.pushButton_analyze.setFont(font)
        self.pushButton_analyze.setObjectName("pushButton_analyze")
        self.gridLayout.addWidget(self.pushButton_analyze, 2, 1, 1, 1)
        self.pushButton_download = QtWidgets.QPushButton(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_download.setFont(font)
        self.pushButton_download.setObjectName("pushButton_download")
        self.gridLayout.addWidget(self.pushButton_download, 0, 2, 1, 1)
        self.label = QtWidgets.QLabel(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(14)
        self.label.setFont(font)
        self.label.setObjectName("label")
        self.gridLayout.addWidget(self.label, 3, 2, 1, 1)
        self.textBrowser_matched = QtWidgets.QTextBrowser(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.textBrowser_matched.setFont(font)
        self.textBrowser_matched.setObjectName("textBrowser_matched")
        self.gridLayout.addWidget(self.textBrowser_matched, 4, 2, 1, 1)
        self.comboBox_select_test = QtWidgets.QComboBox(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_select_test.setFont(font)
        self.comboBox_select_test.setObjectName("comboBox_select_test")
        self.comboBox_select_test.addItem("")
        self.comboBox_select_test.addItem("")
        self.comboBox_select_test.addItem("")
        self.gridLayout.addWidget(self.comboBox_select_test, 1, 1, 1, 1)
        self.comboBox_select_sample = QtWidgets.QComboBox(self.centralwidget)
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_select_sample.setFont(font)
        self.comboBox_select_sample.setObjectName("comboBox_select_sample")
        self.comboBox_select_sample.addItem("")
        self.comboBox_select_sample.addItem("")
        self.comboBox_select_sample.addItem("")
        self.gridLayout.addWidget(self.comboBox_select_sample, 0, 1, 1, 1)
        self.horizontalLayout_6.addLayout(self.gridLayout)
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        self.comboBox_select_sample.activated['QString'].connect(get_sample_string)
        self.comboBox_select_test.activated['QString'].connect(get_test_string)
        self.pushButton_analyze.clicked.connect(analyze_now)
        self.pushButton.clicked.connect(self.textBrowser_process.clear)
        self.pushButton.clicked.connect(self.textBrowser_matched.clear)
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Gene Analyzer"))
        self.label_2.setText(_translate("MainWindow", "Matched rs-number"))
        self.pushButton.setText(_translate("MainWindow", "Clear the results"))
        self.pushButton_export.setText(_translate("MainWindow", "Export results"))
        self.pushButton_analyze.setText(_translate("MainWindow", "Analyze"))
        self.pushButton_download.setText(_translate("MainWindow", "Download a New Test"))
        self.label.setText(_translate("MainWindow", "Matched data (rs-number & genotype)"))
        self.comboBox_select_test.setItemText(0, _translate("MainWindow", "Select a Test"))
        self.comboBox_select_test.setItemText(1, _translate("MainWindow", "Celiac disease"))
        self.comboBox_select_test.setItemText(2, _translate("MainWindow", "Peanut allergy"))
        self.comboBox_select_sample.setItemText(0, _translate("MainWindow", "Select a Sample"))
        self.comboBox_select_sample.setItemText(1, _translate("MainWindow", "Anjan Contractor"))
        self.comboBox_select_sample.setItemText(2, _translate("MainWindow", "Chia-Yun Chou"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

