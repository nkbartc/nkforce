#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    this->setFixedSize(QSize(561, 602));
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

QByteArray analyze(QString sample_name,
             QList<QPair<QByteArray, QByteArray>> tar_gene,
             int start, int num){

    QByteArray data_matches;
    QByteArray &data_matches_ref = data_matches;

    QFile file(sample_name);
    QFile &file_ref = file;
    file.open(QIODevice::ReadOnly);

    int counter = 0;
    int& counter_ref = counter;
    int& start_ref = start;
    // skip first 20 lines
    if (start_ref == 0){
        for(int i = 0; i < 20; i++){
            file_ref.readLine();
            counter++;
        }
    }
    else{
        for(int i = 0; i < start_ref; i++){
            file_ref.readLine();
        }
    }

    // last section to read, triggered by num = -1
    if (num == -1){
        while(!file_ref.atEnd()){
            const QByteArray &line = file_ref.readLine();
            const QList<QByteArray> &tokens = line.split('\t');
            for (const auto &i : tar_gene){
                if (i.first == tokens[0]){
                    const QByteArray &i_rs = i.first;
                    const QByteArray &i_geno = i.second;
                    const QByteArray &cur_geno = tokens[3].split('\r')[0];
                    if(cur_geno.length() == 2){
                        if (i_geno.front() == cur_geno.front() ||
                            i_geno.front() == cur_geno.at(1)){
                            data_matches_ref += i_rs + '-' + i_geno + '\n';
                            break;
                        }
                    }
                    else if (cur_geno.length() == 1) {
                        if (i_geno.front() == cur_geno.front()){
                            data_matches_ref += i_rs + '-' + i_geno + '\n';
                            break;
                        }
                    }
                }
            }
            counter_ref++;
        }
        return data_matches_ref;
    }
    // you don't need this if you don't want to do multithreading/async
    else{
        const int& end = num;
        while(counter_ref != end){
            const QByteArray &line = file_ref.readLine();
            const QList<QByteArray> &tokens = line.split('\t');
            for (const auto &i : tar_gene){
                if (i.first == tokens[0]){
                    const QByteArray &i_rs = i.first;
                    const QByteArray &i_geno = i.second;
                    const QByteArray &cur_geno = tokens[3].split('\r')[0];
                    if(cur_geno.length() == 2){
                        if (i_geno.front() == cur_geno.front() ||
                            i_geno.front() == cur_geno.at(1)){
                            data_matches_ref += i_rs + '-' + i_geno + '\n';
                            break;
                        }
                    }
                    else if (cur_geno.length() == 1) {
                        if (i_geno.front() == cur_geno.front()){
                            data_matches_ref += i_rs + '-' + i_geno + '\n';
                            break;
                        }
                    }
                }
            }
            counter_ref++;
        }
        return data_matches_ref;
    }

}

QList<QPair<QByteArray, QByteArray>> readTest(QString test){
    QList<QPair<QByteArray, QByteArray>> tar_gene;
    QFile file(test);
    file.open(QIODevice::ReadOnly);
    file.readLine(); // skip first line
    while(!file.atEnd()){
        const QByteArray &line = file.readLine();
        QList<QByteArray> templist;
        templist.append(line.split('\t')[20].split('-'));
        tar_gene.append(qMakePair(templist.at(0),
                                  templist.at(1)));
    }
//    note that some of the tests contain duplicated rs-number
////////////////make tar_gene contain only unique rs-number///////////////
////////////////may not give any speed boost//////////////////////////////
//    qSort(tar_gene.begin(), tar_gene.end());
//    QList<QPair<QByteArray, QByteArray>>::iterator it = std::unique (tar_gene.begin(), tar_gene.end());
//    tar_gene.erase(it, tar_gene.end());
/////////////////////////////////////////////////////////////////////////

    return tar_gene;
}

QByteArray foo(QString test, QString sample){
    if(test == "RUN ALL TESTS (Patience!)"){
        QByteArray result;
        QDirIterator it("./tests", QDirIterator::Subdirectories);
        it.next(); // skip . -> current folder
        it.next(); // skip ..-> parent folder
        clock_t t1,t2;
        sample = "./samples/" + sample;
        t1=clock();
        while (it.hasNext()) {
            it.next();
            QString filename(it.fileName());
            QList<QPair<QByteArray, QByteArray>> tar_gene;
            filename = "./tests/" + filename;
            tar_gene = readTest(filename);
            QByteArray result_temp = analyze(sample, tar_gene, 0, -1);
            int numMatched = 0;
            for(int i = 0; i < result_temp.length(); i++){
                if(result_temp[i] == '\n'){
                    numMatched++;
                }
            }
            result += "Test: " + filename + "\n" + result_temp +
                      "Matched data: " + QByteArray::number(numMatched) + "\n" +
                      "--------------------------------------" + "\n";
        }
        t2=clock();
        float diff = t2 - t1;
        float seconds = diff / CLOCKS_PER_SEC;
        qDebug() << seconds;
        return result;
    }
    else{
        test = "./tests/" + test;
        sample = "./samples/" + sample;
        QList<QPair<QByteArray, QByteArray>> tar_gene;
        QFile file_test(test);
        if (!file_test.exists()) {
            return "The test file doesn't exist.";
        }
        tar_gene = readTest(test);
        QFile file_sample(sample);
        if (!file_sample.exists()) {
            return "The sample file doesn't exist.";
        }
        clock_t t1,t2;

        t1=clock();
        QByteArray result_temp = analyze(sample, tar_gene, 0, -1);
        t2=clock();
        float diff = t2 - t1;
        float seconds = diff / CLOCKS_PER_SEC;
        qDebug() << seconds;
        int numMatched = 0;
        for(int i = 0; i < result_temp.length(); i++){
            if(result_temp[i] == '\n'){
                numMatched++;
            }
        }
        QByteArray result;
        result += "Test: " + test + "\n" + result_temp +
                "Matched data: " + QByteArray::number(numMatched) + "\n";
        return result;
    }
}

void MainWindow::on_pushButton_analyze_clicked()
{
    if(ui->comboBox_sample->currentIndex() == 0){
        ui->textBrowser_rsgeno->setText("Select a sample.");
        return;
    }
    if(ui->comboBox_test->currentIndex() == 0){
        ui->textBrowser_rsgeno->setText("Select a test.");
        return;
    }
//    qDebug() << ui->comboBox_sample->currentText();
    QString sample = ui->comboBox_sample->currentText();
    QString test = ui->comboBox_test->currentText();
    QByteArray result = foo(test, sample);
//    QList<QPair<QByteArray, QByteArray>> tar_gene;

//    QFile file_test(test);
//    if (!file_test.exists()) {
//        ui->textBrowser_rsgeno->setText("The test file doesn't exist.");
//        return;
//    }

//    tar_gene = readTest(test);

//    QFile file_sample(sample);
//    if (!file_sample.exists()) {
//        ui->textBrowser_rsgeno->setText("The sample file doesn't exist.");
//        return;
//    }
//    clock_t t1,t2;

//    t1=clock();
//////////////////////// multithreading/////////////////////////////////
//    std::thread th4 = std::thread(analyze, sample, tar_gene, 750000, -1);
//    std::thread th3 = std::thread(analyze, sample, tar_gene, 500000, 250000);
//    std::thread th2 = std::thread(analyze, sample, tar_gene, 250000, 250000);
//    std::thread th1 = std::thread(analyze, sample, tar_gene, 0, 250000);

//    QString result = analyze(sample, tar_gene, 0, 0);
//    th4.join();
//    th3.join();
//    th2.join();
//    th1.join();
////////////////////////////////////////////////////////////////////////

    // the last two arguments stand for
    // where to start reading the sample file and
    // how many lines it should read, respectively
    // PS: set the last arg with -1 to read until EOF
//    QByteArray result = analyze(sample, tar_gene, 0, -1);


/////////////////////////////////async//////////////////////////////////
//    using Future = std::future<QByteArray>;
//    std::vector<Future> futures;
//    int numThread = 1;
//    int factor = 1000000 / numThread;
//    processWin processwin;
//    processwin.setModal(true);
//    processwin.show();
//    for (int i = numThread - 1; i > -1; i--){
//        qDebug() << "here";
//            if (i == numThread - 1){
//                auto temp = std::async(std::launch::async, analyze, sample, tar_gene, i*factor, -1);
//                futures.push_back(std::move(temp));
//                continue;;
//            }
//            auto temp = std::async(std::launch::async, analyze, sample, tar_gene, i*factor, factor);
//            futures.push_back(std::move(temp));
//        }
//        for (auto &part : futures){
//            result += part.get();
//        }
////////////////////////////////////////////////////////////////////////
//    t2=clock();
//    float diff = t2 - t1;
//    float seconds = diff / CLOCKS_PER_SEC;
//    qDebug() << seconds;

//    int numMatched = 0;
//    for(int i = 0; i < result.length(); i++){
//        if(result[i] == '\n'){
//            numMatched++;
//        }
//    }

    ui->textBrowser_rsgeno->setText(result);
//    ui->textBrowser_rsgeno->append("Matched data: " + QString::number(numMatched));
}

void MainWindow::on_actionAuthor_triggered()
{
    Dialog dialog;
    dialog.setModal(true);
    dialog.exec();
}

void MainWindow::on_pushButton_importSamples_clicked()
{
    QDirIterator it("./samples", QDirIterator::Subdirectories);
    ui->comboBox_sample->clear();
    it.next(); // skip . -> current folder
    it.next(); // skip ..-> parent folder
    ui->comboBox_sample->addItem("Select a sample.");
    while (it.hasNext()) {
        it.next();
        QString filename(it.fileName());
        ui->comboBox_sample->addItem(filename);
    }
}

void MainWindow::on_pushButton_importTests_clicked()
{
    QDirIterator it("./tests", QDirIterator::Subdirectories);
    ui->comboBox_test->clear();
    it.next(); // skip . -> current folder
    it.next(); // skip ..-> parent folder
    ui->comboBox_test->addItem("Select a test.");
    while (it.hasNext()) {
        it.next();
        QString filename(it.fileName());
        ui->comboBox_test->addItem(filename);
    }
    ui->comboBox_test->addItem("RUN ALL TESTS (Patience!)");
}

void MainWindow::on_pushButton_download_clicked()
{
    QUrl address = QUrl("https://www.ebi.ac.uk/gwas/search");
    QDesktopServices::openUrl(address);
}

void MainWindow::on_pushButton_export_clicked()
{
    QString name = ui->comboBox_sample->currentText() +
                   "_" +
                   ui->comboBox_test->currentText() +
                   ".txt";
    QFile file(name);
    file.open(QIODevice::ReadWrite|QIODevice::Text);
    QTextStream stream(&file);
    stream << ui->textBrowser_rsgeno->toPlainText();
}
