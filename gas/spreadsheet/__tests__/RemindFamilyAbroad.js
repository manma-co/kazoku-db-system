const assert = require('power-assert')
const pino = require('pino')()

const {
  helper,
  remindFamilyAbroad,
} = require('../RemindFamilyAbroad')


describe('RemindFamilyAbroad', () => {
  const MAM_COLUMN = {
    TIMESTAMP: 0,  // A1 記入日
    MANMA_member: 1,  // B1 担当
    FAMILY_NAME: 2,  // C1 お名前（家庭）
    FAMILY_EMAIL: 3,  // D1 ご連絡先（家庭）
    CAN_FAMILY_ABROAD: 4,  // E1 受け入れ可否
    STUDENT_NAME_1: 5,  // F1 参加学生名（1人目）
    STUDENT_EMAIL_1: 6,  // G1 参加学生の連絡先（1人目）
    STUDENT_NAME_2: 7,  // H1 参加学生名（2人目）
    STUDENT_EMAIL_2: 8,  // I1 参加学生の連絡先（2人目）
    STUDENT_NAME_3: 9,  // J1 参加学生名（3人目）
    STUDENT_EMAIL_3: 10,  // K1 参加学生の連絡先（3人目）
    FAMILY_CONSTRUCTION: 11,  // L1 受け入れ家庭の家族構成
    START_DATE: 12,  // M1 実施日時
    START_TIME: 13,  // N1 実施開始時間
    FINISH_TIME: 14,  // O1 実施終了時間
    MTG_PLACE: 15,  // P1 集合場所
    POSSIBLE_DATE: 16,  // Q1 受け入れ可能な日程
    NULL: 17,  // R1
    MAM_CHECK: 18,  // S1 manmaチェック欄
    IS_EMAIL_SENT: 19,  // T1 sent欄
    MAM_REPLY_CHECK: 20,  // U1 manma　返信確認
    IS_CONFIRM_EMAIL_SENT: 21,  // V1 実施sent欄
  }
  describe('helper', () => {

    describe('canFamilyAbroad', () => {
      let given
      beforeEach(() => {
        given = new Array(4)
      })
      test('受け入れ可能', () => {
        given.push('はい')
        assert.deepStrictEqual(helper().common.canFamilyAbroad(given, MAM_COLUMN), true)
      })
      test('受け入れ不可能', () => {
        given.push('いいえ')
        assert.deepStrictEqual(helper().common.canFamilyAbroad(given, MAM_COLUMN), false)
      })
    })
    describe('isEmailSent', () => {
      let given
      beforeEach(() => {
        given = new Array(20)
      })
      test('通知メール送信済み', () => {
        given.push('2018/10/5')
        assert.deepStrictEqual(helper().common.isEmailSent(given, MAM_COLUMN), true)
      })
      test('通知メール未送信', () => {
        given.push('')
        assert.deepStrictEqual(helper().common.isEmailSent(given, MAM_COLUMN), true)
      })
    })
    describe('getStudentName', () => {
      let given
      beforeEach(() => {
        given = new Array(5)
      })
      test('学生1人の場合', () => {
        given.push('大学 花子')
        given.push('')
        given.push('')
        given.push('')
        given.push('')
        given.push('')
        assert.deepStrictEqual(helper().common.getStudentName(given, MAM_COLUMN), '大学 花子さま')
      })
      test('学生2人の場合', () => {
        given.push('大学 花子')
        given.push('')
        given.push('大学 次郎')
        given.push('')
        given.push('')
        given.push('')
        assert.deepStrictEqual(helper().common.getStudentName(given, MAM_COLUMN), '大学 花子さま,大学 次郎さま')
      })
      test('学生3人の場合', () => {
        given.push('大学 花子')
        given.push('')
        given.push('大学 次郎')
        given.push('')
        given.push('大学 三郎')
        given.push('')
        assert.deepStrictEqual(helper().common.getStudentName(given, MAM_COLUMN), '大学 花子さま,大学 次郎さま,大学 三郎さま')
      })
    })
    describe('getStudentEmail', () => {
      let given
      beforeEach(() => {
        given = new Array(5)
      })
      test('学生1人の場合', () => {
        given.push('大学 花子')
        given.push('daigaku_hanako@test.com')
        given.push('')
        given.push('')
        given.push('')
        given.push('')
        assert.deepStrictEqual(helper().common.getStudentEmail(given, MAM_COLUMN), 'daigaku_hanako@test.com')
      })
      test('学生2人の場合', () => {
        given.push('大学 花子')
        given.push('daigaku_hanako@test.com')
        given.push('大学 次郎')
        given.push('daigaku_jiro@test.com')
        given.push('')
        given.push('')
        assert.deepStrictEqual(helper().common.getStudentEmail(given, MAM_COLUMN), 'daigaku_hanako@test.com,daigaku_jiro@test.com')
      })
      test('学生3人の場合', () => {
        given.push('大学 花子')
        given.push('daigaku_hanako@test.com')
        given.push('大学 次郎')
        given.push('daigaku_jiro@test.com')
        given.push('大学 三郎')
        given.push('daigaku_saburo@test.com')
        assert.deepStrictEqual(helper().common.getStudentEmail(given, MAM_COLUMN), 'daigaku_hanako@test.com,daigaku_jiro@test.com,daigaku_saburo@test.com')
      })
    })
    describe('getFamilyAbroadStartDateTime', () => {
      let given
      beforeEach(() => {
        given = new Array(12)
      })
      test('2018/10/05 10:00はDateに変換される', () => {
        given.push('2018/10/05')
        given.push('10:00:00')
        assert.deepStrictEqual(
          helper().common.getFamilyAbroadStartDateTime(given, MAM_COLUMN),
          new Date('2018/10/05 10:000:00')
        )
      })
    })
  })

  describe('remindFamilyAbroad', () => {
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
    describe('2018年6月3日18:00~21:00に家族留学がある', () => {
      let given
      let spreadSheetAppMock
      let remindFn
      beforeEach(() => {
        given = [
          [
            'timestamp',
            '担当者',
            '家庭のお名前',
            'family@gmail.com',
            'はい',
            '学生1',
            'student1@gmail.com',
            '学生2',
            'student2@gmail.com',
            '学生3',
            'student3@gmail.com',
            '家族構成',
            '2018/6/3',
            '18:00:00',
            '21:00:00',
            '北千住駅前',
            '使っていない受け入れ可能な日程',
            '謎のnull',
            '使っていないmanmaチェック欄',
            '使っていないsent欄',
            '使っていない返信確認欄',
            '',
          ]
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
          remindFamilyAbroad({
            COLUMN: MAM_COLUMN,
            SpreadsheetApp: spreadSheetAppMock,
            GmailApp: gmailAppMock,
            Logger: loggerMock,
            startRow: 0,
            currentDate,
          })
        }
      })
      describe('リマインドメールが送信される', () => {
        test('現在の日付が2018年5月24日の場合', () => {
          const currentDate = new Date(2018, 5 - 1, 24)
          remindFn(currentDate)
          const expected = [
            ["timestamp", "担当者", "家庭のお名前", "family@gmail.com", "はい", "学生1", "student1@gmail.com", "学生2", "student2@gmail.com", "学生3", "student3@gmail.com", "家族構成", "2018/6/3", "18:00:00", "21:00:00", "北千住駅前", "使っていない受け入れ可能な日程", "謎のnull", "使っていないmanmaチェック欄", "使っていないsent欄", "使っていない返信確認欄", "2018/05/24"]
          ]
          assert.deepStrictEqual(given, expected)
        })
        test('現在の日付が2018年6月1日の場合', () => {
          const currentDate = new Date(2018, 6 - 1, 1)
          remindFn(currentDate)
          const expected = [
            ["timestamp", "担当者", "家庭のお名前", "family@gmail.com", "はい", "学生1", "student1@gmail.com", "学生2", "student2@gmail.com", "学生3", "student3@gmail.com", "家族構成", "2018/6/3", "18:00:00", "21:00:00", "北千住駅前", "使っていない受け入れ可能な日程", "謎のnull", "使っていないmanmaチェック欄", "使っていないsent欄", "使っていない返信確認欄", "2018/06/01"]
          ]
          assert.deepStrictEqual(given, expected)
        })
        test('現在の日付が2018年6月3日の場合', () => {
          const currentDate = new Date(2018, 6 - 1, 3)
          remindFn(currentDate)
          const expected = [
            ["timestamp", "担当者", "家庭のお名前", "family@gmail.com", "はい", "学生1", "student1@gmail.com", "学生2", "student2@gmail.com", "学生3", "student3@gmail.com", "家族構成", "2018/6/3", "18:00:00", "21:00:00", "北千住駅前", "使っていない受け入れ可能な日程", "謎のnull", "使っていないmanmaチェック欄", "使っていないsent欄", "使っていない返信確認欄", "2018/06/03"]
          ]
          assert.deepStrictEqual(given, expected)
        })
      })
      describe('リマインドメールが送信されない', () => {
        test('現在の日付が2018年5月23日の場合', () => {
          const currentDate = new Date(2018, 5 - 1, 23)
          remindFn(currentDate)
          const expected = [
            ["timestamp", "担当者", "家庭のお名前", "family@gmail.com", "はい", "学生1", "student1@gmail.com", "学生2", "student2@gmail.com", "学生3", "student3@gmail.com", "家族構成", "2018/6/3", "18:00:00", "21:00:00", "北千住駅前", "使っていない受け入れ可能な日程", "謎のnull", "使っていないmanmaチェック欄", "使っていないsent欄", "使っていない返信確認欄", ""]
          ]
          assert.deepStrictEqual(given, expected)
        })
        test('現在の日付が2018年6月4日の場合', () => {
          const currentDate = new Date(2018, 6 - 1, 4)
          remindFn(currentDate)
          const expected = [
            ["timestamp", "担当者", "家庭のお名前", "family@gmail.com", "はい", "学生1", "student1@gmail.com", "学生2", "student2@gmail.com", "学生3", "student3@gmail.com", "家族構成", "2018/6/3", "18:00:00", "21:00:00", "北千住駅前", "使っていない受け入れ可能な日程", "謎のnull", "使っていないmanmaチェック欄", "使っていないsent欄", "使っていない返信確認欄", ""]
          ]
          assert.deepStrictEqual(given, expected)
        })
        test('現在の日付が2018年6月5日の場合', () => {
          const currentDate = new Date(2018, 6 - 1, 5)
          remindFn(currentDate)
          const expected = [
            ["timestamp", "担当者", "家庭のお名前", "family@gmail.com", "はい", "学生1", "student1@gmail.com", "学生2", "student2@gmail.com", "学生3", "student3@gmail.com", "家族構成", "2018/6/3", "18:00:00", "21:00:00", "北千住駅前", "使っていない受け入れ可能な日程", "謎のnull", "使っていないmanmaチェック欄", "使っていないsent欄", "使っていない返信確認欄", ""]
          ]
          assert.deepStrictEqual(given, expected)
        })

      })
    })
  })
})
