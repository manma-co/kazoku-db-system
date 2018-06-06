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

  describe('2018年6月9日に面談がある', () => {
    let given
    let spreadSheetAppMock
    let remindFn
    beforeEach(() => {
      given = [
        ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
      ]
      spreadSheetAppMock = {
        getActive: () => {
          return {
            getSheetByName: (sheetName) => {
              return sheetMock(given)
            },
          }
        },
        flush: () => { },
      }
      remindFn = currentDate => {
        remind({
          COLUMN: columnMock,
          SpreadsheetApp: spreadSheetAppMock,
          GmailApp: gmailAppMock,
          Logger: loggerMock,
          startRow: 0,
          currentDate,
        })
      }
    })
    describe('リマインドメールが送信される', () => {
      test('現在の日付が6月6日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 6) // 2018年6月6日
        remindFn(currentDate)
        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '2018/06/06']
        ]
        assert.deepStrictEqual(given, expected)
      })
      test('現在の日付が6月7日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 7) // 2018年6月7日
        remindFn(currentDate)

        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '2018/06/07']
        ]
        assert.deepStrictEqual(given, expected)
      })
      test('現在の日付が6月8日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 8) // 2018年6月8日
        remindFn(currentDate)
        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '2018/06/08']
        ]
        assert.deepStrictEqual(given, expected)
      })
      test('現在の日付が6月9日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 9) // 2018年6月9日
        remindFn(currentDate)
        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '2018/06/09']
        ]
        assert.deepStrictEqual(given, expected)
      })
    })
    describe('リマインドメールが送信されない', () => {
      test('現在の日付が6月4日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 4) // 2018年6月4日
        remindFn(currentDate)
        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
        ]
        assert.deepStrictEqual(given, expected)
      })
      test('現在の日付が6月5日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 5) // 2018年6月5日
        remindFn(currentDate)

        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
        ]
        assert.deepStrictEqual(given, expected)
      })
      test('現在の日付が6月10日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 10) // 2018年6月10日
        remindFn(currentDate)
        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
        ]
        assert.deepStrictEqual(given, expected)
      })
      test('現在の日付が6月11日の場合', () => {
        const currentDate = new Date(2018, 6 - 1, 11) // 2018年6月11日
        remindFn(currentDate)
        const expected = [
          ['お名前', 'hogehoge@gmail.com', '2018年6月9日 17:00~18:00', '', '']
        ]
        assert.deepStrictEqual(given, expected)
      })
    })
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
