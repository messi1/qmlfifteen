#ifndef HIGHSCORELISTMODEL_H
#define HIGHSCORELISTMODEL_H

#include <QAbstractListModel>
#include <QObject>
#include <QSettings>
#include <highscoreentry.h>

class HighScoreListModel : public QAbstractListModel
{
    Q_OBJECT
public:
    enum HighScoreRoles {
        ModeRole = Qt::UserRole + 1,
        TimeRole,
        NameRole
    };

    HighScoreListModel(QObject *parent=0);
    ~HighScoreListModel();

    QVariant data(const QModelIndex &index, int role) const;
    bool setData(const QModelIndex &index, const QVariant &value, int role);
    QHash<int, QByteArray> roleNames() const;
    int rowCount(const QModelIndex &parent) const;
    void loadHighScoreList();
    void saveHighScoreList();

public slots:
    bool checkIfEntryWillBeSaved(const quint64& timeInMs, const int &mode);

private:
    typedef QList<HighScoreEntry> HighScoreList;
    QSettings     m_settings;
    HighScoreList m_highScoreList;
};

#endif // HIGHSCORELISTMODEL_H
