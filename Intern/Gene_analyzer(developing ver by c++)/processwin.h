#ifndef PROCESSWIN_H
#define PROCESSWIN_H

#include <QDialog>

namespace Ui {
class processWin;
}

class processWin : public QDialog
{
    Q_OBJECT

public:
    explicit processWin(QWidget *parent = nullptr);
    ~processWin();

private:
    Ui::processWin *ui;
};

#endif // PROCESSWIN_H
