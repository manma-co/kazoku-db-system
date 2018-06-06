const assert = require('power-assert')
const pino = require('pino')()

const {
  remind,
  convertDate
} = require('../面接希望日時3日前リマインドメール送信')

describe('remind', () => {
  const columnMock = {
    NAME: 0, // C1: 氏名
    EMAIL: 1, // F2: メールアドレス
    INTERVIEW_DATE: 2,  // P1: 面談希望日時（場所：JR大塚駅付近）
    INTERVIEW_DATE_ONLINE: 3, // R1: 面談希望日時
    IS_REMIND: 4  // U1: リマインドメール送信済み確認(システム利用)
  }

  const sheetMock = (rows) => {
    return {
      getLastRow: () => {
        return 0
      },
      getLastColumn: () => {
        return 0
      },
      getRange: (row, col) => {
        return {
          getValues: () => {
            return rows
          },
          setValue: (v) => {
            // TODO: colが+1された値で渡ってくるため-1する ← やめたい
            const c = col - 1
            rows[row][c] = v
          },
        }
      },
    }
  }

  const loggerMock = {
    log: (str) => {
      pino.info(str)
    }
  }

  const gmailAppMock = {
    sendEmail: () => { }
  }

  test('リマンドメールが送信される', () => {
    const given = [
      ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
    ]
    const spreadSheetAppMock = {
      getActive: () => {
        return {
          getSheetByName: (sheetName) => {
            return sheetMock(given)
          },
        }
      },
      flush: () => { },
    }
    remind({
      COLUMN: columnMock,
      SpreadsheetApp: spreadSheetAppMock,
      GmailApp: gmailAppMock,
      Logger: loggerMock,
      startRow: 0,
      currentDate: new Date(2018, 6 - 1, 6)
    })

    const expected = [
      ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '2018/06/06']
    ]
    assert.deepStrictEqual(given, expected)
  })
  test('リマンドメールが送信されない', () => {
    const given = [
      ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
    ]
    const spreadSheetAppMock = {
      getActive: () => {
        return {
          getSheetByName: (sheetName) => {
            return sheetMock(given)
          },
        }
      },
      flush: () => { },
    }
    remind({
      COLUMN: columnMock,
      SpreadsheetApp: spreadSheetAppMock,
      GmailApp: gmailAppMock,
      Logger: loggerMock,
      startRow: 0,
      currentDate: new Date(2018, 6 - 1, 7)
    })

    const expected = [
      ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
    ]
    assert.deepStrictEqual(given, expected)
  })
})

describe('convertDate', () => {
  test('2018年5月4日 17:00~ は正しくDate型に変換される', () => {
    const given = '2018年5月4日 17:00~'
    const expect = new Date('2018/5/4 17:00')
    assert.deepStrictEqual(convertDate(given), expect)
  })
  test('2018年5月4日 17:00~18:00 は正しくDate型に変換される', () => {
    const given = '2018年5月4日 17:00~18:00'
    const expect = new Date('2018/5/4 17:00')
    assert.deepStrictEqual(convertDate(given), expect)
  })
})
