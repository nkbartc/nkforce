#ifndef MAINWINDOW_H
#define MAINWINDOW_H

#include <QDir>
#include <unistd.h>
#include <QMainWindow>
#include <sys/stat.h>
#include <string>
#include <fstream>
#include <tuple>
#include <iostream>
#include <sstream>
#include <vector>
#include <thread>
#include <QTextStream>
#include <QDebug>
#include <QFile>
#include <time.h>
#include <QMessageBox>
#include <dialog.h>
#include <thread>
#include <chrono>
#include <future>
#include <processwin.h>
#include <QDirIterator>
#include <QtCore>
#include <QDesktopServices>


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
    void on_pushButton_analyze_clicked();

    void on_actionAuthor_triggered();

    void on_pushButton_importSamples_clicked();

    void on_pushButton_importTests_clicked();

    void on_pushButton_download_clicked();

    void on_pushButton_export_clicked();

private:
    Ui::MainWindow *ui;
};

#endif // MAINWINDOW_H
