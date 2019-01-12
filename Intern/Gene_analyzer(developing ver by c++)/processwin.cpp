#include "processwin.h"
#include "ui_processwin.h"

processWin::processWin(QWidget *parent) :
    QDialog(parent),
    ui(new Ui::processWin)
{
    ui->setupUi(this);
}

processWin::~processWin()
{
    delete ui;
}
