# -*- coding: utf-8 -*-

# Form implementation generated from reading ui file 'PN_3.ui'
#
# Created by: PyQt5 UI code generator 5.11.3
#
# WARNING! All changes made in this file will be lost!

from PyQt5 import QtCore, QtGui, QtWidgets

male = True
female = False
height_feet = "Select a Number"
height_inch = "Select a Number"
weight = 150
age = "Select a Number"
purpose = "Select a Type"
min = 30
heart_rate = 70
intensity = "Select a Number"
leanfactor_string = "Select a Number"

def bmr_male(p, h_f, h_i, y):  # p = pound, h_f = height in feet, h_i = height in inches, y = age
    t_h = h_f * 12 + h_i
    result = 66 + 6.23 * p + 12.7 * t_h - 6.8 * y
    return round(result)


def bmr_female(p, h_f, h_i, y):
    t_h = h_f * 12 + h_i
    result = 655 + 4.35 * p + 4.7 * t_h - 4.7 * y
    return round(result)

def get_leanfactor(leanfactor_string):
    lean_index = int(leanfactor_string[0])
    # lean index 1: multiplier is 1
    # lean index 2: multiplier is 0.95
    # lean index 3: multiplier is 0.90
    # lean index 4: multiplier is 0.85
    switcher = {1: 1,
                2: 0.95,
                3: 0.9,
                4: 0.85}
    return switcher.get(lean_index)

def calculate():
    global male, female, height_feet, height_inch, weight
    global age, purpose, min, heart_rate, intensity, leanfactor_string
    # check if the program has all the required info to continue
    if (height_feet == "Select a Number" or
        height_inch == "Select a Number" or
        age == "Select a Number" or
        purpose == "Select a Type" or
        intensity == "Select a Number" or
        leanfactor_string == "Select a Number"):
        ui.textBrowser_result.setText("fail to calculate. Make sure you have all the "
                                      "required number selected.")
        return None

    bmr = 0
    result = ""
    if male == True and female == False:
        result = result + "-"*13 + "given data" + "-"*13 + "\n" + \
                 "Gender: Male" + "\n"
        bmr = bmr_male(int(weight), int(height_feet), int(height_inch), int(age))

    elif male == False and female == True:
        result = result + "-"*13 + "given data" + "-"*13 + "\n" + \
                 "Gender: Female" + "\n"
        bmr = bmr_female(int(weight), int(height_feet), int(height_inch), int(age))
    leanfactor = get_leanfactor(leanfactor_string)
    result = result + \
             "Height: " + str(height_feet) + " feet  " + str(height_inch) + " inches" + "\n" + \
             "Weight: " + str(weight) + " pounds" + "\n" + \
             "Age: " + str(age) + "\n" + \
             "Purpose: " + purpose + "\n" + \
             "Physical activity rating: " + str(round(int(min) * float(intensity))) + "\n" + \
             "Heart rate: " + str(heart_rate) + "\n" + \
             "Lean factor: " + str(leanfactor) + "\n" + \
             "-"*12 + "the analysis" + "-"*12 + "\n" + \
             "BMR: " + str(bmr) + "\n" + \
             "Cals per day: " + str(round(bmr * leanfactor)) + "\n" + \
             "Cals per hour: "+ str(round(bmr * leanfactor * (1/24))) + "\n"

    ui.textBrowser_result.setText(result)

def radioButton(task):
    global male, female
    if task == "male":
        male = ui.radioButton_male.isChecked()

    elif task == "female":
        female = ui.radioButton_female.isChecked()

def spin_box(task):
    global weight, min, heart_rate
    if task == "weight":
        weight = ui.spinBox.value()

    elif task == "min":
        min = ui.spinBox_2.value()

    elif task == "heart_rate":
        heart_rate = ui.spinBox_3.value()

def combo_box(task):
    global height_feet, height_inch, age, purpose, intensity, leanfactor_string
    if task == "feet":
        height_feet = ui.comboBox_feet.currentText()
    elif task == "inch":
        height_inch = ui.comboBox_inches.currentText()
    elif task == "age":
        age = ui.comboBox_age.currentText()
    elif task == "purpose":
        purpose = ui.comboBox_purpose.currentText()
    elif task == "intensity":
        intensity = ui.comboBox_intensity.currentText()
    elif task == "leanfactor":
        leanfactor_string = ui.comboBox_leanfactor.currentText()

class Ui_MainWindow(object):
    def setupUi(self, MainWindow):
        MainWindow.setObjectName("MainWindow")
        MainWindow.resize(756, 689)
        self.centralwidget = QtWidgets.QWidget(MainWindow)
        self.centralwidget.setObjectName("centralwidget")
        self.listWidget_allergies_after = QtWidgets.QListWidget(self.centralwidget)
        self.listWidget_allergies_after.setGeometry(QtCore.QRect(480, 270, 256, 192))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.listWidget_allergies_after.setFont(font)
        self.listWidget_allergies_after.setObjectName("listWidget_allergies_after")
        self.textBrowser_result = QtWidgets.QTextBrowser(self.centralwidget)
        self.textBrowser_result.setGeometry(QtCore.QRect(30, 520, 341, 131))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.textBrowser_result.setFont(font)
        self.textBrowser_result.setObjectName("textBrowser_result")
        self.pushButton_calculate = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_calculate.setGeometry(QtCore.QRect(30, 470, 161, 41))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_calculate.setFont(font)
        self.pushButton_calculate.setObjectName("pushButton_calculate")
        self.pushButton_clear = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_clear.setGeometry(QtCore.QRect(210, 470, 161, 41))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_clear.setFont(font)
        self.pushButton_clear.setObjectName("pushButton_clear")
        self.label_6 = QtWidgets.QLabel(self.centralwidget)
        self.label_6.setGeometry(QtCore.QRect(190, 90, 61, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_6.setFont(font)
        self.label_6.setObjectName("label_6")
        self.label_5 = QtWidgets.QLabel(self.centralwidget)
        self.label_5.setGeometry(QtCore.QRect(31, 91, 49, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_5.setFont(font)
        self.label_5.setObjectName("label_5")
        self.comboBox_age = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_age.setGeometry(QtCore.QRect(118, 117, 142, 25))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_age.setFont(font)
        self.comboBox_age.setObjectName("comboBox_age")
        for x in range(101):
            self.comboBox_age.addItem("")
        self.label_7 = QtWidgets.QLabel(self.centralwidget)
        self.label_7.setGeometry(QtCore.QRect(31, 117, 28, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_7.setFont(font)
        self.label_7.setObjectName("label_7")
        self.label_3 = QtWidgets.QLabel(self.centralwidget)
        self.label_3.setGeometry(QtCore.QRect(270, 60, 29, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_3.setFont(font)
        self.label_3.setObjectName("label_3")
        self.label_4 = QtWidgets.QLabel(self.centralwidget)
        self.label_4.setGeometry(QtCore.QRect(480, 60, 46, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_4.setFont(font)
        self.label_4.setObjectName("label_4")
        self.label_9 = QtWidgets.QLabel(self.centralwidget)
        self.label_9.setGeometry(QtCore.QRect(31, 148, 71, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_9.setFont(font)
        self.label_9.setObjectName("label_9")
        self.radioButton_female = QtWidgets.QRadioButton(self.centralwidget)
        self.radioButton_female.setGeometry(QtCore.QRect(190, 30, 73, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.radioButton_female.setFont(font)
        self.radioButton_female.setObjectName("radioButton_female")
        self.comboBox_feet = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_feet.setGeometry(QtCore.QRect(118, 60, 142, 25))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_feet.setFont(font)
        self.comboBox_feet.setEditable(False)
        self.comboBox_feet.setObjectName("comboBox_feet")
        for x in range(9):
            self.comboBox_feet.addItem("")
        self.radioButton_male = QtWidgets.QRadioButton(self.centralwidget)
        self.radioButton_male.setGeometry(QtCore.QRect(120, 30, 55, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.radioButton_male.setFont(font)
        self.radioButton_male.setChecked(True)
        self.radioButton_male.setObjectName("radioButton_male")
        self.label_8 = QtWidgets.QLabel(self.centralwidget)
        self.label_8.setGeometry(QtCore.QRect(270, 120, 39, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_8.setFont(font)
        self.label_8.setObjectName("label_8")
        self.label = QtWidgets.QLabel(self.centralwidget)
        self.label.setGeometry(QtCore.QRect(31, 31, 51, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label.setFont(font)
        self.label.setObjectName("label")
        self.label_2 = QtWidgets.QLabel(self.centralwidget)
        self.label_2.setGeometry(QtCore.QRect(31, 60, 46, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_2.setFont(font)
        self.label_2.setObjectName("label_2")
        self.comboBox_inches = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_inches.setGeometry(QtCore.QRect(330, 60, 142, 25))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_inches.setFont(font)
        self.comboBox_inches.setObjectName("comboBox_inches")
        for x in range(13):
            self.comboBox_inches.addItem("")
        self.comboBox_purpose = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_purpose.setGeometry(QtCore.QRect(118, 148, 120, 25))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_purpose.setFont(font)
        self.comboBox_purpose.setObjectName("comboBox_purpose")
        for x in range(3):
            self.comboBox_purpose.addItem("")
        self.label_15 = QtWidgets.QLabel(self.centralwidget)
        self.label_15.setGeometry(QtCore.QRect(31, 267, 61, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_15.setFont(font)
        self.label_15.setObjectName("label_15")
        self.label_13 = QtWidgets.QLabel(self.centralwidget)
        self.label_13.setGeometry(QtCore.QRect(31, 236, 91, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_13.setFont(font)
        self.label_13.setObjectName("label_13")
        self.comboBox_leanfactor = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_leanfactor.setGeometry(QtCore.QRect(118, 236, 498, 25))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_leanfactor.setFont(font)
        self.comboBox_leanfactor.setObjectName("comboBox_leanfactor")
        for x in range(5):
            self.comboBox_leanfactor.addItem("")
        self.label_14 = QtWidgets.QLabel(self.centralwidget)
        self.label_14.setGeometry(QtCore.QRect(520, 180, 61, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_14.setFont(font)
        self.label_14.setObjectName("label_14")
        self.label_12 = QtWidgets.QLabel(self.centralwidget)
        self.label_12.setGeometry(QtCore.QRect(31, 210, 74, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_12.setFont(font)
        self.label_12.setObjectName("label_12")
        self.label_11 = QtWidgets.QLabel(self.centralwidget)
        self.label_11.setGeometry(QtCore.QRect(31, 179, 81, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_11.setFont(font)
        self.label_11.setObjectName("label_11")
        self.comboBox_intensity = QtWidgets.QComboBox(self.centralwidget)
        self.comboBox_intensity.setGeometry(QtCore.QRect(380, 180, 133, 25))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.comboBox_intensity.setFont(font)
        self.comboBox_intensity.setObjectName("comboBox_intensity")
        for x in range(11):
            self.comboBox_intensity.addItem("")
        self.listWidget_allergies_before = QtWidgets.QListWidget(self.centralwidget)
        self.listWidget_allergies_before.setGeometry(QtCore.QRect(118, 267, 256, 192))
        font = QtGui.QFont()
        font.setPointSize(10)
        self.listWidget_allergies_before.setFont(font)
        self.listWidget_allergies_before.setObjectName("listWidget_allergies_before")
        item = QtWidgets.QListWidgetItem()
        item.setFlags(QtCore.Qt.ItemIsDragEnabled|QtCore.Qt.ItemIsUserCheckable|QtCore.Qt.ItemIsEnabled)
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        item = QtWidgets.QListWidgetItem()
        self.listWidget_allergies_before.addItem(item)
        self.pushButton_allergies_delete = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_allergies_delete.setGeometry(QtCore.QRect(380, 300, 91, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_allergies_delete.setFont(font)
        self.pushButton_allergies_delete.setObjectName("pushButton_allergies_delete")
        self.pushButton_allergies_add = QtWidgets.QPushButton(self.centralwidget)
        self.pushButton_allergies_add.setGeometry(QtCore.QRect(380, 270, 91, 23))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.pushButton_allergies_add.setFont(font)
        self.pushButton_allergies_add.setObjectName("pushButton_allergies_add")
        self.label_10 = QtWidgets.QLabel(self.centralwidget)
        self.label_10.setGeometry(QtCore.QRect(190, 180, 172, 19))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.label_10.setFont(font)
        self.label_10.setObjectName("label_10")
        self.spinBox = QtWidgets.QSpinBox(self.centralwidget)
        self.spinBox.setGeometry(QtCore.QRect(120, 90, 61, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.spinBox.setFont(font)
        self.spinBox.setButtonSymbols(QtWidgets.QAbstractSpinBox.NoButtons)
        self.spinBox.setMinimum(1)
        self.spinBox.setMaximum(999)
        self.spinBox.setProperty("value", 150)
        self.spinBox.setObjectName("spinBox")
        self.spinBox_2 = QtWidgets.QSpinBox(self.centralwidget)
        self.spinBox_2.setGeometry(QtCore.QRect(120, 180, 61, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.spinBox_2.setFont(font)
        self.spinBox_2.setButtonSymbols(QtWidgets.QAbstractSpinBox.NoButtons)
        self.spinBox_2.setKeyboardTracking(True)
        self.spinBox_2.setMinimum(1)
        self.spinBox_2.setMaximum(999)
        self.spinBox_2.setProperty("value", 30)
        self.spinBox_2.setObjectName("spinBox_2")
        self.spinBox_3 = QtWidgets.QSpinBox(self.centralwidget)
        self.spinBox_3.setGeometry(QtCore.QRect(120, 210, 61, 21))
        font = QtGui.QFont()
        font.setPointSize(12)
        self.spinBox_3.setFont(font)
        self.spinBox_3.setButtonSymbols(QtWidgets.QAbstractSpinBox.NoButtons)
        self.spinBox_3.setMinimum(10)
        self.spinBox_3.setMaximum(200)
        self.spinBox_3.setProperty("value", 70)
        self.spinBox_3.setObjectName("spinBox_3")
        MainWindow.setCentralWidget(self.centralwidget)
        self.statusbar = QtWidgets.QStatusBar(MainWindow)
        self.statusbar.setObjectName("statusbar")
        MainWindow.setStatusBar(self.statusbar)

        self.retranslateUi(MainWindow)
        self.radioButton_male.toggled['bool'].connect(lambda: radioButton("male"))
        self.radioButton_female.toggled['bool'].connect(lambda: radioButton("female"))
        self.comboBox_feet.activated['QString'].connect(lambda: combo_box("feet"))
        self.comboBox_inches.activated['QString'].connect(lambda: combo_box("inch"))
        self.comboBox_age.activated['QString'].connect(lambda: combo_box("age"))
        self.comboBox_purpose.activated['QString'].connect(lambda: combo_box("purpose"))
        self.comboBox_intensity.activated['QString'].connect(lambda: combo_box("intensity"))
        self.comboBox_leanfactor.activated['QString'].connect(lambda: combo_box("leanfactor"))
        self.pushButton_calculate.clicked.connect(calculate)
        self.pushButton_clear.clicked.connect(self.textBrowser_result.clear)
        self.listWidget_allergies_before.itemClicked['QListWidgetItem*'].connect(self.pushButton_allergies_add.click)
        self.pushButton_allergies_delete.clicked.connect(self.listWidget_allergies_after.lower)
        self.spinBox.editingFinished.connect(lambda: spin_box("weight"))
        self.spinBox_2.editingFinished.connect(lambda: spin_box("min"))
        self.spinBox_3.editingFinished.connect(lambda: spin_box("heart_rate"))
        QtCore.QMetaObject.connectSlotsByName(MainWindow)

    def retranslateUi(self, MainWindow):
        _translate = QtCore.QCoreApplication.translate
        MainWindow.setWindowTitle(_translate("MainWindow", "Personalized Nutrition Analyzer"))
        self.pushButton_calculate.setText(_translate("MainWindow", "Calculate"))
        self.pushButton_clear.setText(_translate("MainWindow", "Clear the results"))
        self.label_6.setText(_translate("MainWindow", "Pounds"))
        self.label_5.setText(_translate("MainWindow", "Weight"))
        self.comboBox_age.setItemText(0, _translate("MainWindow", "Select a Number"))
        for x in range(1, 101):
            self.comboBox_age.setItemText(x, _translate("MainWindow", str(x)))
        self.label_7.setText(_translate("MainWindow", "Age"))
        self.label_3.setText(_translate("MainWindow", "Feet"))
        self.label_4.setText(_translate("MainWindow", "Inches"))
        self.label_9.setToolTip(_translate("MainWindow", "Is this a meal?  Is this a snack? Etc."))
        self.label_9.setStatusTip(_translate("MainWindow", "Is this a meal?  Is this a snack? Etc."))
        self.label_9.setText(_translate("MainWindow", "Purpose*"))
        self.radioButton_female.setText(_translate("MainWindow", "Female"))
        self.comboBox_feet.setItemText(0, _translate("MainWindow", "Select a Number"))
        for x in range(1, 9):
            self.comboBox_feet.setItemText(x, _translate("MainWindow", str(x)))
        self.radioButton_male.setText(_translate("MainWindow", "Male"))
        self.label_8.setText(_translate("MainWindow", "Years"))
        self.label.setText(_translate("MainWindow", "Gender"))
        self.label_2.setText(_translate("MainWindow", "Height"))
        self.comboBox_inches.setItemText(0, _translate("MainWindow", "Select a Number"))
        for x in range(1, 13):
            self.comboBox_inches.setItemText(x, _translate("MainWindow", str(x-1)))
        self.comboBox_purpose.setToolTip(_translate("MainWindow", "Is this a meal?  Is this a snack? Etc."))
        self.comboBox_purpose.setStatusTip(_translate("MainWindow", "Is this a meal?  Is this a snack? Etc."))
        self.comboBox_purpose.setItemText(0, _translate("MainWindow", "Select a Type"))
        self.comboBox_purpose.setItemText(1, _translate("MainWindow", "Meal"))
        self.comboBox_purpose.setItemText(2, _translate("MainWindow", "Snack"))
        self.label_15.setText(_translate("MainWindow", "Allergies"))
        self.label_13.setText(_translate("MainWindow", "Lean Factor"))
        self.comboBox_leanfactor.setItemText(0, _translate("MainWindow", "Select a Number"))
        self.comboBox_leanfactor.setItemText(1, _translate("MainWindow", "1: (Lean) Men (10% to <14%) - Women 14% to <18%"))
        self.comboBox_leanfactor.setItemText(2, _translate("MainWindow", "2: (Normal) Men (14% to <20%) - Women 18% to <28%"))
        self.comboBox_leanfactor.setItemText(3, _translate("MainWindow", "3: (Clinically Obese) Men (20% to <28%) - Women 28% to <38%"))
        self.comboBox_leanfactor.setItemText(4, _translate("MainWindow", "4: (Chronically Obese) Men (over 28%) - Women over 38%"))
        self.label_14.setText(_translate("MainWindow", "Intensity"))
        self.label_12.setText(_translate("MainWindow", "Heart Rate"))
        self.label_11.setToolTip(_translate("MainWindow", "Physical Activity Rating = # of minutes of exercise * intensity"))
        self.label_11.setStatusTip(_translate("MainWindow", "Physical Activity Rating = # of minutes of exercise * intensity"))
        self.label_11.setText(_translate("MainWindow", "PA Rating*"))
        self.comboBox_intensity.setItemText(0, _translate("MainWindow", "Select Intensity"))
        self.comboBox_intensity.setItemText(1, _translate("MainWindow", "0.1"))
        self.comboBox_intensity.setItemText(2, _translate("MainWindow", "0.2"))
        self.comboBox_intensity.setItemText(3, _translate("MainWindow", "0.3"))
        self.comboBox_intensity.setItemText(4, _translate("MainWindow", "0.4"))
        self.comboBox_intensity.setItemText(5, _translate("MainWindow", "0.5"))
        self.comboBox_intensity.setItemText(6, _translate("MainWindow", "0.6"))
        self.comboBox_intensity.setItemText(7, _translate("MainWindow", "0.7"))
        self.comboBox_intensity.setItemText(8, _translate("MainWindow", "0.8"))
        self.comboBox_intensity.setItemText(9, _translate("MainWindow", "0.9"))
        self.comboBox_intensity.setItemText(10, _translate("MainWindow", "1.0"))
        __sortingEnabled = self.listWidget_allergies_before.isSortingEnabled()
        self.listWidget_allergies_before.setSortingEnabled(False)
        item = self.listWidget_allergies_before.item(0)
        item.setText(_translate("MainWindow", "(List of common food allergies)"))
        item = self.listWidget_allergies_before.item(1)
        item.setText(_translate("MainWindow", "Milk (mostly in children)"))
        item = self.listWidget_allergies_before.item(2)
        item.setText(_translate("MainWindow", "Eggs"))
        item = self.listWidget_allergies_before.item(3)
        item.setText(_translate("MainWindow", "Peanuts"))
        item = self.listWidget_allergies_before.item(4)
        item.setText(_translate("MainWindow", "Tree nuts, like walnuts, almonds, pine nuts, brazil nuts, and pecans."))
        item = self.listWidget_allergies_before.item(5)
        item.setText(_translate("MainWindow", "Soy"))
        item = self.listWidget_allergies_before.item(6)
        item.setText(_translate("MainWindow", "Wheat and other grains with gluten, including barley, rye, and oats."))
        item = self.listWidget_allergies_before.item(7)
        item.setText(_translate("MainWindow", "Fish (mostly in adults)"))
        item = self.listWidget_allergies_before.item(8)
        item.setText(_translate("MainWindow", "Shellfish (mostly in adults)"))
        self.listWidget_allergies_before.setSortingEnabled(__sortingEnabled)
        self.pushButton_allergies_delete.setText(_translate("MainWindow", "<< Delete"))
        self.pushButton_allergies_add.setText(_translate("MainWindow", "Add >>"))
        self.label_10.setText(_translate("MainWindow", "# of minutes of exercise"))


if __name__ == "__main__":
    import sys
    app = QtWidgets.QApplication(sys.argv)
    MainWindow = QtWidgets.QMainWindow()
    ui = Ui_MainWindow()
    ui.setupUi(MainWindow)
    MainWindow.show()
    sys.exit(app.exec_())

