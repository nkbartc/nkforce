/*
Property of BeeHex, LLC
All rights reserved.
Developer: Bart Chou
*/

#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <bits/stdc++.h>
#include <QMainWindow>
#include <string>
#include <math.h>
#include <QMessageBox>

using namespace std;
extern bool male, female;
extern int weights, bodyfat, age, minutes, heartrate;
extern int eggs, milk, peanuts, treenuts, fish, shellfish, wheat, soy;
extern string feet, inches, intake, intensity, leanfactor, fitnessgoal, exercise;

namespace Ui {
class MainWindow;
}

class MainWindow : public QMainWindow
{
    Q_OBJECT

public:
    explicit MainWindow(QWidget *parent = nullptr);
    ~MainWindow();

private slots:
    void on_radioButton_male_toggled(bool checked);

    void on_radioButton_female_toggled(bool checked);



    void on_comboBox_inches_activated(const QString &arg1);

    void on_spinBox_weights_editingFinished();

    void on_spinBox_bodyfat_editingFinished();

    void on_spinBox_age_editingFinished();

    void on_comboBox_intake_activated(const QString &arg1);

    void on_spinBox_minutes_editingFinished();

    void on_comboBox_intensity_activated(const QString &arg1);

    void on_spinBox_heartrate_editingFinished();

    void on_comboBox_leanfactor_activated(const QString &arg1);

    void on_comboBox_fitnessgoal_activated(const QString &arg1);

    void on_comboBox_exercise_activated(const QString &arg1);

    void on_checkBox_eggs_stateChanged(int arg1);

    void on_checkBox_milk_stateChanged(int arg1);

    void on_checkBox_peanuts_stateChanged(int arg1);

    void on_checkBox_treenuts_stateChanged(int arg1);

    void on_checkBox_fish_stateChanged(int arg1);

    void on_checkBox_shellfish_stateChanged(int arg1);

    void on_checkBox_wheat_stateChanged(int arg1);

    void on_checkBox_soy_stateChanged(int arg1);

    void on_pushButton_calculate_clicked();

    void on_actionAuthor_triggered(bool checked);

    void on_radioButton_male_clicked();

    void on_radioButton_female_clicked();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
