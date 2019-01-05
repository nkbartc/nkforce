/*
Property of BeeHex, LLC
All rights reserved.
Developer: Bart Chou
*/

#include "mainwindow.h"
#include "ui_mainwindow.h"

MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

void MainWindow::on_radioButton_male_toggled(bool checked){

}

void MainWindow::on_radioButton_female_toggled(bool checked){

}



void MainWindow::on_comboBox_inches_activated(const QString &arg1){

}

void MainWindow::on_spinBox_weights_editingFinished(){

}

void MainWindow::on_spinBox_bodyfat_editingFinished(){

}

void MainWindow::on_spinBox_age_editingFinished(){

}

void MainWindow::on_comboBox_intake_activated(const QString &arg1){

}

void MainWindow::on_spinBox_minutes_editingFinished(){

}

void MainWindow::on_comboBox_intensity_activated(const QString &arg1){

}

void MainWindow::on_spinBox_heartrate_editingFinished(){

}

void MainWindow::on_comboBox_leanfactor_activated(const QString &arg1){

}

void MainWindow::on_comboBox_fitnessgoal_activated(const QString &arg1){

}

void MainWindow::on_comboBox_exercise_activated(const QString &arg1){

}

void MainWindow::on_checkBox_eggs_stateChanged(int arg1){

}

void MainWindow::on_checkBox_milk_stateChanged(int arg1){

}

void MainWindow::on_checkBox_peanuts_stateChanged(int arg1){

}

void MainWindow::on_checkBox_treenuts_stateChanged(int arg1){

}

void MainWindow::on_checkBox_fish_stateChanged(int arg1){

}

void MainWindow::on_checkBox_shellfish_stateChanged(int arg1){

}

void MainWindow::on_checkBox_wheat_stateChanged(int arg1){

}

void MainWindow::on_checkBox_soy_stateChanged(int arg1){

}

void MainWindow::on_radioButton_male_clicked(){

}

void MainWindow::on_radioButton_female_clicked(){

}

int get_protein(float lbw, int fitnessgoal_idx, int exercise_idx){
    // daily protein intake = lean body weight * factor
    float factor = 0.0;
    if(exercise_idx == 1){
        switch (fitnessgoal_idx) {
        case 1:
            factor = float(0.6);
            break;
        case 2:
            factor = float(0.7);
            break;
        case 3:
            factor = float(0.8);
            break;
        case 4:
            factor = float(0.7);
            break;
        }
    }
    else if(exercise_idx == 2){
        switch (fitnessgoal_idx) {
        case 1:
            factor = float(0.7);
            break;
        case 2:
            factor = float(0.9);
            break;
        case 3:
            factor = float(0.9);
            break;
        case 4:
            factor = float(0.9);
            break;
        }
    }
    else if(exercise_idx == 3){
        switch (fitnessgoal_idx) {
        case 1:
            factor = float(0.8);
            break;
        case 2:
            factor = float(1.0);
            break;
        case 3:
            factor = float(1.6);
            break;
        case 4:
            factor = float(1.4);
            break;
        }
    }
    else if(exercise_idx == 4){
        switch (fitnessgoal_idx) {
        case 1:
            factor = float(0.8);
            break;
        case 2:
            factor = float(1.4);
            break;
        case 3:
            factor = float(1.8);
            break;
        case 4:
            factor = float(1.6);
            break;
        }
    }
    int result = static_cast<int>(round(lbw * factor));
    return result;
}

float get_lbw(int weights, int bodyfat){
    float fat = bodyfat * float(0.01);
    float lbw = (1-fat) * weights;
    return lbw;
}

int get_cal(float bmr, int leanfactor_idx){
    float leanfactor = 0.0;
    switch (leanfactor_idx) {
    case 1:
        leanfactor = 1.0;
        break;
    case 2:
        leanfactor = float(0.95);
        break;
    case 3:
        leanfactor = float(0.9);
        break;
    case 4:
        leanfactor = float(0.85);
        break;
    }
    float cal = bmr * leanfactor;
    int result = static_cast<int>(round(cal));
    return result;
}

float get_bmr(bool gender,int weights, int feet, int inches, int age){
    if(gender){
        // male
        int temp = 12 * feet + inches; // height in inches
        float bmr = float(66 + (6.23 * weights) + (12.7 * temp) - (6.8 * age));
        return bmr;
    }
    else{
        // female
        int temp = 12 * feet + inches; // height in inches
        float bmr = float(655 + (4.35 * weights) + (4.7 * temp) - (4.7 * age));
        return bmr;
    }
}

void MainWindow::on_pushButton_calculate_clicked()
{
    if(ui->comboBox_feet->currentIndex() == 0 ||
       ui->comboBox_inches->currentIndex() == 0 ||
       ui->comboBox_intake->currentIndex() == 0 ||
       ui->comboBox_intensity->currentIndex() == 0 ||
       ui->comboBox_leanfactor->currentIndex() == 0 ||
       ui->comboBox_fitnessgoal->currentIndex() == 0 ||
       ui->comboBox_exercise->currentIndex() == 0){
        ui->textBrowser_result->setText("fail to calculate. Make sure you have all the"
                                        "required number selected.");
        return;
    }
    int weights = ui->spinBox_weights->value();
    int bodyfat = ui->spinBox_bodyfat->value();
    int age     = ui->spinBox_age->value();
    int minutes = ui->spinBox_minutes->value();
    int heartrate = ui->spinBox_heartrate->value();
    int feet = ui->comboBox_feet->currentText().toInt();
    int inches = ui->comboBox_inches->currentText().toInt();
    string intake = ui->comboBox_intake->currentText().toStdString();
    int intensity = ui->comboBox_intensity->currentText().toInt();
    int leanfactor_idx = ui->comboBox_leanfactor->currentIndex();
    int fitnessgoal_idx = ui->comboBox_fitnessgoal->currentIndex();
    int exercise_idx = ui->comboBox_exercise->currentIndex();
    float bmr = get_bmr(ui->radioButton_male->isChecked(), weights, feet, inches, age);
    int cal = get_cal(bmr, leanfactor_idx);
    float lbw = get_lbw(weights, bodyfat);
    int protein = get_protein(lbw, fitnessgoal_idx, exercise_idx);

    string report = "";
    report = "Cals per day: " + std::to_string(cal) + "\n" + \
             "Protein per day: " + std::to_string(protein) + "\n";
    ui->textBrowser_result->setText(QString::fromStdString(report));
}

void MainWindow::on_actionAuthor_triggered(bool checked)
{
    QMessageBox messageBox;
    messageBox.setWindowTitle("About");
    messageBox.setText("Property of BeeHex, LLC\n"
                       "All rights reserved.\n"
                       "Developer: Bart Chou");
    messageBox.setWindowTitle("About");
    messageBox.exec();
//    QMessageBox::information(this, "About", "Property of BeeHex, LLC\n"
//                                            "All rights reserved.\n"
//                                            "Developer: Bart Chou");
}
