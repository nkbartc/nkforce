"""
Property of BeeHex, LLC
All rights reserved.
Developer: Bart Chou
"""

import csv, time, multiprocessing, os.path

from itertools import islice
from PyQt5 import QtCore, QtGui, QtWidgets
from PyQt5.QtGui import QDesktopServices


class Test:
    tar_gene = []

    def __init__(self, test_name):
        tar_gene = []
        source = open(test_name, "r", encoding='UTF-8', newline='')
        source_reader = csv.DictReader(source, delimiter="\t")
        for row in source_reader:
            temp = (row['STRONGEST SNP-RISK ALLELE']).split("-")
            tar_gene.append((temp[0], temp[1]))
        self.tar_gene = tar_gene


def analyze(rsid_queue, gene_queue, sample_name, tar_gene, start, end):
    process_rsid = ""
    result = ""
    # num_matched = 0
    sample = open(sample_name, "r", encoding='UTF-8', newline='')
    for i in range(19): # skip first 19 lines. may need a better way to reach
        next(sample)    # the line we want later
    for row in islice(csv.DictReader(sample, delimiter="\t"), start, end):
        rsid = row['# rsid']
        genotype = row["genotype"]
        for tar in tar_gene:
            if tar[0] == rsid:
                # print("rsid match")
                process_rsid = process_rsid + rsid + "\n"
                if len(genotype) == 2:
                    if tar[1] == genotype[0] or tar[1] == genotype[1]:
                        result = result + tar[0] + "-" + tar[1] + "\n"
                        break
                        # num_matched = num_matched + 1
                elif len(genotype) == 1:
                    if tar[1] == genotype[0]:
                        result = result + tar[0] + "-" + tar[1] + "\n"
                        break
                        # num_matched = num_matched + 1
    # result = result + "\n" + str(num_matched) + "\n"
    # if len(result) == 0:
    #     result = "No matched data"
    rsid_queue.put(process_rsid)
    gene_queue.put(result)
    # return process_rsid, result


sample_string = "Select a Sample"
test_string = "Select a Test"


def analyze_now():
    global sample_string, test_string

    if sample_string != "Select a Sample" and test_string != "Select a Test":
        temp_sample = sample_string + ".tsv"
        temp_test = test_string + ".tsv"
        if not os.path.exists(temp_sample):
            ui.textBrowser_process.setText("Could not find the sample file: " + temp_sample)
            return
        if os.path.exists(temp_test):
            data = Test(temp_test)
        else:
            ui.textBrowser_process.setText("Could not find the test file: " + temp_test)
            return

        rsid_queue = multiprocessing.Queue()
        gene_queue = multiprocessing.Queue()

        p1 = multiprocessing.Process(target=analyze, args=(rsid_queue, gene_queue,
                                                           temp_sample, data.tar_gene, 0, 250000,))
        p2 = multiprocessing.Process(target=analyze, args=(rsid_queue, gene_queue,
                                                           temp_sample, data.tar_gene, 250000, 500000,))
        p3 = multiprocessing.Process(target=analyze, args=(rsid_queue, gene_queue,
                                                           temp_sample, data.tar_gene, 500000, 750000,))
        p4 = multiprocessing.Process(target=analyze, args=(rsid_queue, gene_queue,
                                                           temp_sample, data.tar_gene, 750000, None,))
        start = time.time()

        p4.start()
        p3.start()
        p2.start()
        p1.start()

        p1.join()
        p2.join()
        p3.join()
        p4.join()
        end = time.time()
        print(end - start)

        final_rsid = ""
        final_result = ""

        for x in range(4):
            final_rsid = final_rsid + rsid_queue.get()
            final_result = final_result + gene_queue.get()
        numMatched = 0

        for x in range(len(final_result)):
            if final_result[x] == '\n':
                numMatched += 1

        ui.textBrowser_process.setText(final_rsid)
        ui.textBrowser_matched.setText(final_result)
        ui.textBrowser_matched.append("Matched data: " + str(numMatched))


def get_sample_string(s):
    global sample_string
    sample_string = s


def get_test_string(s):
    global test_string
    test_string = s

def link():
    address = QtCore.QUrl("https://www.ebi.ac.uk/gwas/search")
    QDesktopServices.openUrl(address)

def export():
    fileName = sample_string + '_' + test_string + '.txt'
    file = open(fileName, "w+")
    content = "Matched data (rs-number & genotype)\n" + \
              ui.textBrowser_matched.toPlainText() + \
              "\nMatched rs-number\n" + \
              ui.textBrowser_process.toPlainText()
    file.write(content)

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
        self.pushButton_download.clicked.connect(link)
        self.pushButton_export.clicked.connect(export)
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
        self.comboBox_select_test.setItemText(3, _translate("MainWindow", "PTSD"))
        self.comboBox_select_test.setItemText(4, _translate("MainWindow", "Anxiety disorder"))
        self.comboBox_select_test.setItemText(5, _translate("MainWindow", "Obesity"))
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

