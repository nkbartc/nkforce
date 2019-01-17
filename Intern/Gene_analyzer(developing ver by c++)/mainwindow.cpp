#include "mainwindow.h"
#include "ui_mainwindow.h"


MainWindow::MainWindow(QWidget *parent) :
    QMainWindow(parent),
    ui(new Ui::MainWindow)
{
    this->setFixedSize(QSize(617, 681));
    ui->setupUi(this);
}

MainWindow::~MainWindow()
{
    delete ui;
}

QMap<QByteArray, QByteArray> readSample(QString sample_name){

    QMap<QByteArray, QByteArray> result;
    QMap<QByteArray, QByteArray> &result_ref = result;

    QFile file(sample_name);
    QFile &file_ref = file;
    file.open(QIODevice::ReadOnly);

    // skip first 20 lines
    for(int i = 0; i < 20; i++){
        file_ref.readLine();
    }

    while(!file_ref.atEnd()){
        const QByteArray &line = file_ref.readLine();
        const QList<QByteArray> &tokens = line.split('\t');
        result_ref.insert(tokens[0], tokens[3].split('\r')[0]);
    }
    return result;
}

QVector<QPair<QByteArray, QByteArray>> readTest(QString test, int& numTestGene){
    QVector<QPair<QByteArray, QByteArray>> result;
    QVector<QPair<QByteArray, QByteArray>> &result_ref = result;
    QFile file(test);
    file.open(QIODevice::ReadOnly);
    file.readLine(); // skip first line
    while(!file.atEnd()){
        const QByteArray &line = file.readLine();
        QList<QByteArray> templist;
        templist.append(line.split('\t')[20].split('-'));
        result_ref.append(qMakePair(templist.at(0), templist.at(1)));
        numTestGene++;
    }
//    note that some of the tests contain duplicated rs-number
////////////////make result contain only unique rs-number///////////////
    qSort(result_ref.begin(), result_ref.end());
    QVector<QPair<QByteArray, QByteArray>>::iterator it = std::unique (result_ref.begin(), result_ref.end());
    result_ref.erase(it, result_ref.end());
///////////////////////////////////////////////////////////////////////
    return result;
}

QByteArray foo(QString test, QString sample){
    if(test == "RUN ALL TESTS"){
        QByteArray result;
        QDirIterator it("./tests", QDirIterator::Subdirectories);
        it.next(); // skip . -> current folder
        it.next(); // skip ..-> parent folder
        clock_t t1,t2;
        sample = "./samples/" + sample;
        QMap<QByteArray, QByteArray> sampleMap;
        QMap<QByteArray, QByteArray> const &sampleMap_ref = sampleMap;
        t1=clock();
        sampleMap = readSample(sample);
        while (it.hasNext()) {
            it.next();
            QString filename(it.fileName());
            QByteArray tempResult;
            filename = "./tests/" + filename;
            QVector<QPair<QByteArray, QByteArray>> testMap;
            int numTestGene = 0;
            testMap = readTest(filename, numTestGene);
            int numMatched = 0;
            for (const auto &i : testMap){
                if (sampleMap_ref.contains(i.first)){
                    const QByteArray &i_rs = i.first;
                    const QByteArray &i_geno = i.second;
                    if (sampleMap_ref.find(i_rs)->length() == 2){
                        if (i_geno.front() == sampleMap_ref.value(i_rs).front() ||
                            i_geno.front() == sampleMap_ref.value(i_rs).at(1)){
                            tempResult += i_rs + '-' + i_geno + '\n';
                            numMatched++;
                        }
                    }
                    else if (sampleMap_ref.find(i_rs)->length() == 1){
                        if (i_geno.front() == sampleMap_ref.value(i_rs).front()){
                            tempResult += i_rs + '-' + i_geno + '\n';
                            numMatched++;
                        }
                    }
                }
            }
            float per = (float)numMatched/(float)numTestGene * 100;
            result += "Test: " + filename + "\n" + tempResult +
                      "Matched: " + QByteArray::number(numMatched) +
                      " (out of " + QByteArray::number(numTestGene) + ")" +
                      " -> " + QByteArray::number(per) + "%" + "\n" +
                      "--------------------------------------" + "\n";
        }
        t2=clock();
        float diff = t2 - t1;
        float seconds = diff / CLOCKS_PER_SEC;
        qDebug() << seconds;
        return result;
    }
    else{
        QByteArray result, tempResult;
        test = "./tests/" + test;
        sample = "./samples/" + sample;
//        QFile file_test(test);
//        if (!file_test.exists()) {
//            return "The test file doesn't exist.";
//        }

//        QFile file_sample(sample);
//        if (!file_sample.exists()) {
//            return "The sample file doesn't exist.";
//        }
        clock_t t1,t2;
        QMap<QByteArray, QByteArray> sampleMap;
        QMap<QByteArray, QByteArray> const &sampleMap_ref = sampleMap;
        t1=clock();
        sampleMap = readSample(sample);
        QVector<QPair<QByteArray, QByteArray>> testMap;
        int numTestGene = 0;
        testMap = readTest(test, numTestGene);
        int numMatched = 0;
        for (const auto &i : testMap){
            if (sampleMap_ref.contains(i.first)){
                const QByteArray &i_rs = i.first;
                const QByteArray &i_geno = i.second;
                if (sampleMap_ref.find(i_rs)->length() == 2){
                    if (i_geno.front() == sampleMap_ref.value(i_rs).front() ||
                        i_geno.front() == sampleMap_ref.value(i_rs).at(1)){
                        tempResult += i_rs + '-' + i_geno + '\n';
                        numMatched++;
                    }
                }
                else if (sampleMap_ref.find(i_rs)->length() == 1){
                    if (i_geno.front() == sampleMap_ref.value(i_rs).front()){
                        tempResult += i_rs + '-' + i_geno + '\n';
                        numMatched++;
                    }
                }
            }
        }
        result += "Test: " + test + "\n" + tempResult +
                  "Matched data: " + QByteArray::number(numMatched) +
                  " (out of" + QByteArray::number(numTestGene) + ")" + "\n" +
                  "--------------------------------------" + "\n";
        t2=clock();
        float diff = t2 - t1;
        float seconds = diff / CLOCKS_PER_SEC;
        qDebug() << seconds;
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
    ui->comboBox_test->addItem("RUN ALL TESTS");
    while (it.hasNext()) {
        it.next();
        QString filename(it.fileName());
        ui->comboBox_test->addItem(filename);
    }
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
