-- 함수 : 컬럼의 값을 읽어서 연산한 결과를 반환

-- 단일 행 함수 : N개의 값을 읽어 N개의 결과를 반환
-- 그룹 함수 : N개의 값을 읽어서 1개의 결과를 반환 (합계, 평균, 최대, 최소 등)

-- 함수는 SELECT 문의
-- SELECT절, WHERE절, ORDER BY절, HAVING절 등 사용 가능

------------------- 단일 행 함수 -------------------

-- LENGTH(컬럼명 | 문자열) : 길이 반환
SELECT EMAIL, LENGTH(EMAIL)
FROM EMPLOYEE;

-------------------------------------------------

-- INSTR(컬럼명 | 문자열, '찾을 문자열' [, 찾기 시작할 위치 [, 순번]])
-- 지정한 위치부터 지정한 순번째로 검색되는 문자의 위치를 반환

-- 문자열을 앞에서부터 검색하여 첫번째 B 위치를 조회
SELECT INSTR('AABAACAAAABBA', 'B') FROM DUAL;

-- 문자열을 5번째 문자부터 검색하여 첫번째 B 위치 조회
SELECT INSTR('AABAACAAAABBA', 'B', 5) FROM DUAL;

-- 문자열을 5번째 문자부터 검색하여 두번째 B 위치 조회
SELECT INSTR('AABAACAAAABBA', 'B', 5, 2) FROM DUAL;

-- EMPLOYEE 테이블에서 사원명, 이메일, 이메일 중 '@' 위치 조회
SELECT EMP_NAME, EMAIL, INSTR(EMAIL, '@')
FROM EMPLOYEE;

-------------------------------------------------

-- SUBSTR('문자열' | 컬럼명, 잘라내기 시작할 위치 [, 잘라낼 길이])
-- 컬럼이나 문자열에서 지정한 위치부터 길이만큼 문자열을 잘라서 반환
--> 잘라낼 길이 생략 시 끝까지 잘라냄

-- EMPLOYEE 테이블에서 사원명, 이메일 중 아이디만 조회
SELECT EMP_NAME, SUBSTR(EMAIL, 1, INSTR(EMAIL, '@') -1) FROM EMPLOYEE;

-------------------------------------------------

-- TRIM( [[옵션]'문자열' | 컬럼명 FROM]  문자열 | 컬럼명)
-- 주어진 컬럼이나 문자열의 앞, 뒤, 양쪽에 있는 지정된 문자를 제거
--> 양 쪽 공백 제거에 주로 쓰임

-- 옵션 : LEADING(앞쪽), TRAILING(뒷쪽), BOTH(양쪽, 기본값)

SELECT TRIM('        HELLO        ') FROM DUAL;

SELECT TRIM(LEADING '#' FROM '######안녕######') FROM DUAL;

-------------------------------------------------

/* 숫자 관련 함수 */

-- ABS(숫자 | 컬럼명) : 절대 값
SELECT ABS(10), ABS(-10) FROM DUAL;

SELECT '절대값 같음'
FROM DUAL
WHERE ABS(10) = ABS(-10);

-- MOD(숫자 | 컬럼명, 숫자 | 컬럼명) : 나머지 값 반환
-- EMPLOYEE 테이블에서 사원의 월급을 100만으로 나눴을 때 나머지 조회
SELECT EMP_NAME, SALARY, MOD(SALARY, 1000000)
FROM EMPLOYEE;

-- EMPLOYEE 테이블에서 사번이 짝수인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) = 0;

-- EMPLOYEE 테이블에서 사번이 홀수인 사원의 사번, 이름 조회
SELECT EMP_ID, EMP_NAME
FROM EMPLOYEE
WHERE MOD(EMP_ID, 2) <> 0; -- !=와 <>는 동일하게 수행되나, 오라클에선 <>이게 맞긴 하다.


-- ROUND(숫자 | 컬럼명 [, 소수점 위치]) : 반올림
SELECT ROUND(123.456) FROM DUAL; -- 소수점 첫번째 자리에서 반올림
-- SELECT ROUND(123.456, 0) FROM DUAL; -- 자릿수 미작성과 동일 (기본값)

SELECT ROUND(123.456, 1) FROM DUAL; -- 소수점 두번째 자리에서 반올림
									--> 두번째 자리에서 반올림해서 소수점 1자리까지만 표현

SELECT ROUND(123.456, -1) FROM DUAL; -- 소수점 0번째 자리에서 반올림해서 
									--> 소수점 -1 자리 표현
									--> == 1의 자리에서 반올림해서 10의자리부터 표현

-- CEIL(숫자 | 컬럼명) : 올림
-- FLOOR(숫자 | 컬럼명) : 내림
--> 둘 다 소수점 첫째 자리에서 올림/내림 처리

SELECT CEIL(123.1), FLOOR(123.9) FROM DUAL;


-- TRUNC(숫자 | 컬럼명 [, 위치]) : 특정 위치 아래를 버림(절삭)
SELECT TRUNC(123.456) FROM DUAL; -- 소수점 아래를 버림 (기본)
SELECT TRUNC(123.456, 1) FROM DUAL; -- 소수점 첫째 자리 아래를 버림
SELECT TRUNC(123.456, -1) FROM DUAL; -- 10의 자리 아래를 버림

-- 버림, 내림 차이점
SELECT FLOOR(-123.5), TRUNC(-123.5) FROM DUAL;
--	 	 	  -124			 -123

-------------------------------------------------

/* 날짜(DATE) 관련 함수 */

-- SYSDATE : 시스템의 현재 시간(년, 월, 일, 시, 분, 초)를 반환
SELECT SYSDATE FROM DUAL;

-- SYSTIMESTAMP : SYSDATE + MS 단위 추가
SELECT SYSTIMESTAMP FROM DUAL;
-- TIMESTAMP : 특정 시간을 나타내거나 기록하기 위한 문자열

-- MONTH_BETWEEN(날짜, 날짜) : 두 날짜의 개월수 차이 반환
SELECT ROUND(MONTHS_BETWEEN(SYSDATE, '2023-07-10'), 3) "수강 기간(개월)" 
FROM DUAL;  

-- EMPLOYEE 테이블에서
-- 사원의 이름, 입사일, 근무한 개월 수, 근무 년차 조회
SELECT EMP_NAME, HIRE_DATE,
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE)) "근무한 개월 수",
CEIL(MONTHS_BETWEEN(SYSDATE, HIRE_DATE) / 12) || '년차' "근무 년차"
FROM EMPLOYEE;


-- ADD_MONTH(날짜, 숫자) : 날짜에 숫자만큼의 개월 수를 더함. (음수도 가능)
SELECT ADD_MONTHS(SYSDATE, 4) FROM DUAL; 
SELECT ADD_MONTHS(SYSDATE, -1) FROM DUAL; 

-- LAST_DAY(날짜) : 해당 달의 마지막 날짜를 구함.
SELECT LAST_DAY('2023-02-01') FROM DUAL;
SELECT LAST_DAY('2024-02-01') FROM DUAL; 

-- EXTRACT : 년, 월, 일 정보를 추출하여 리턴
-- EXTRACT(YEAR FROM 날짜) : 년도만 추출
-- EXTRACT(MONTH FROM 날짜) : 월만 추출
-- EXTRACT(DAY FROM 날짜) : 일만 추출

-- EMPLOYEE 테이블에서
-- 각 사원의 이름, 입사년도, 월, 일 조회
SELECT EMP_NAME, 
	EXTRACT(YEAR FROM HIRE_DATE) || '년 ' ||
	EXTRACT(MONTH FROM HIRE_DATE) || '월 ' ||
	EXTRACT(DAY FROM HIRE_DATE) || '일' AS 입사일
FROM EMPLOYEE;

-------------------------------------------------

/* 형변환 함수 */
-- 문자열(CHAR), 숫자(NUMBER), 날짜(DATE) 끼리 형변환 가능

/* 문자열로 변환 */
-- TO_CHAR(날짜, [포맷]) : 날짜형 데이터를 문자형 데이터로 변경
-- TO_CHAR(숫자, [포맷]) : 숫자형 데이터를 문자형 데이터로 변경


-- < 숫자 변환 시 포맷 패턴 >
-- 9 : 숫자 한 칸을 의미, 여러개 작성 시 오른쪽 정렬
-- 0 : 숫자 한 칸을 의미, 여러개 작성 시 오른쪽 정렬 + 빈칸 0 추가
-- L : 현재 DB에 설정된 나라의 화폐 기호

SELECT TO_CHAR(1234, '99999') FROM DUAL; -- '1234'
SELECT TO_CHAR(1234, '00000') FROM DUAL; -- '01234'

SELECT TO_CHAR(1000000, 'L9,999,999') FROM DUAL; -- ￦1,000,000
SELECT TO_CHAR(1000000, '$9,999,999') FROM DUAL; --  $1,000,000 (화폐 기호 변경 가능)


-- < 날짜 변환 시 포맷 패턴 >
-- YYYY : 년도 / YY : 년도(짧게)
-- RRRR : 년도 / RR : 년도(짧게)
-- MM : 월
-- DD : 일
-- AM / PM : 오전 / 오후 표시
-- HH : 시간 / HH24 : 24시간 표기법
-- MI : 분
-- SS : 초
-- DAY : 요일(전체) / DY : 요일(요일명만 표시)

SELECT SYSDATE FROM DUAL; -- 2023-01-10 10:21:18.000

-- 2023-01-10 10:21:00 화요일
SELECT TO_CHAR(SYSDATE, 'YYYY-MM-DD HH24:MI:SS DAY') FROM DUAL;

-- 2023년 01월 10일 (화)
SELECT TO_CHAR(SYSDATE, 'YYYY"년" MM"월" DD"일" (DY)') FROM DUAL;

-- SQL Error [1821] [22008]: ORA-01821: 날짜 형식이 부적합합니다
-- 년, 월, 일이 날짜를 나타내는 패턴으로 인식이 안되서 오류 발생
--> "" 쌍따옴표를 이용해서 단순한 문자로 인식시키면 해결


-------------------------------------------------

/* 날짜로 변환 TO_DATE */


-- TO_DATE(문자형 데이터 [, 포맷]) : 문자형 데이터를 날짜로 변환
-- TO_DATE(숫자형 데이터 [, 포맷]) : 숫자형 데이터를 날짜로 변환

SELECT TO_DATE('2023-01-10') FROM DUAL; -- DATE 타입으로 변환
SELECT TO_DATE(20230110) FROM DUAL;

SELECT TO_DATE('510505', 'YYMMDD') FROM DUAL; -- 2051-05-05 00:00:00.000
SELECT TO_DATE('510505', 'RRMMDD') FROM DUAL; -- 1951-05-05 00:00:00.000

-- Y 패턴 : 현재 세기 (21세기 == 20XX년 == 2000년대)
-- R 패턴 : 1세기 기준으로 절반(50년) 이상인 경우 이전 세기(1990년대)
--						   절반(50년) 미만인 경우 현재 세기(2000년대)

-- EMPLOYEE 테이블에서 각 태어난 생년월일(1990년 05월 13일) 조회
SELECT EMP_NAME, 
	TO_CHAR(TO_DATE (SUBSTR(EMP_NO, 1, INSTR(EMP_NO, '-') -1) , 'RRMMDD'), 'YYYY"년" MM"월" DD"일"' )  
	AS 생년월일 
FROM EMPLOYEE;

-------------------------------------------------

/* 숫자 형변환 */
-- TO_NUMBER(문자 데이터, [포맷]) : 문자형 데이터를 숫자 데이터로 변경
-- TO_NUMBER(날짜 데이터, [포맷]) : 날짜형 데이터를 숫자 데이터로 변경

-- SQL Error [1722] [42000]: ORA-01722: 수치가 부적합합니다
SELECT '1,000,000' + 50000 FROM DUAL;

SELECT TO_NUMBER('1,000,000', '9,999,999') + 5000000 FROM DUAL; -- 6000000 (산술된 값이 포맷에 맞춰 출력됨)

-------------------------------------------------

/* NULL 처리 함수 */

-- NVL (컬럼명, 컬럼값이 NULL 일 때 바꿀 값) : NULL인 컬럼값을 다른 값으로 변경

/* NULL과 산술 연산을 진행하면 결과는 NULL */
SELECT EMP_NAME, SALARY, BONUS, NVL(BONUS, 0), SALARY * NVL(BONUS, 0)
FROM EMPLOYEE;

-- NVL2(컬럼명, 바꿀값 1, 바꿀값 2)
-- 해당 컬럼에 값이 있으면 바꿀값 1로 변경
-- 해당 컬럼이 NULL이면 바꿀값 2로 변경

-- EMPLOYEE테이블에서 보너스를 받으면 '0', 안받으면 'X' 조회
SELECT EMP_NAME, NVL2(BONUS, 'O', 'X') FROM EMPLOYEE; 

-------------------------------------------------

/* 선택 함수 */
-- 여러가지 경우에 따라 알맞은 결과를 선택할 수 있음

-- DECODE(계산식 | 컬럼명, 조건값1, 선택값1, 조건값2, 선택값2 ......, 아무것도 일치하지 않을 때 )
-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환
-- 일치하는 값을 확인(자바의 SWITCH와 비슷)

-- 직원의 성별 구하기 (남:1 / 여:2)
SELECT EMP_NAME, EMP_NO, DECODE( SUBSTR(EMP_NO, 8, 1), '1', '남성', '2', '여성' ) 성별
FROM EMPLOYEE;

-- 직원의 급여를 인상하고자 한다.
-- 직급 코드가 J7인 직원은 20% 인상
-- 직급 코드가 J6인 직원은 15% 인상
-- 직급 코드가 J5인 직원은 10% 인상
-- 그 외 직급은 5% 인상
-- 이름, 직급코드, 원래 급여, 인상률, 인상된 급여

SELECT EMP_NAME , JOB_CODE , SALARY , 
DECODE(JOB_CODE, 'J7', '20%', 
				 'J6', '15%', 
				 'J5', '10%', 
				 '5%') 인상률,
DECODE(JOB_CODE, 'J7', SALARY * 1.2, 
				 'J6', SALARY * 1.15, 
				 'J5', SALARY * 1.1, 
				 SALARY * 1.05) "인상된 급여"
FROM EMPLOYEE;

-- CASE WHEN 조건식 TEHN 결과값
-- 		WHEN 조건식 THEN 결과값
-- 		ELSE 결과값
-- END

-- 비교하고자 하는 값 또는 컬럼이 조건식과 같으면 결과값 반환
-- 조건은 범위 값 가능

-- EMPLOYEE 테이블에서
-- 급여가 500만원 이상이면 '대'
-- 급여가 300만원 이상 500만원 미만이면 '중'
-- 급여가 300만원 미만이면 '소'로 조회
SELECT EMP_NAME , SALARY,
	CASE 
		WHEN SALARY >= 5000000 THEN '대'
		WHEN SALARY >= 3000000 THEN '중'
		ELSE '소'		
	END "급여 받는 정도"
FROM EMPLOYEE;

-------------------------------------------------

/* 그룹 함수 */

-- 하나 이상의 행을 그룹으로 묶어 연산하여 총합, 평균 등의 하나의 결과 행으로 반환하는 함수

-- SUM(숫자가 기록된 컬럼명) : 합계
-- 모든 직원의 급여 합

SELECT SUM(SALARY)
FROM EMPLOYEE;

-- AVG(숫자가 기록된 컬럼명) : 평균
-- 전 직원 급여 평균
SELECT ROUND( AVG(SALARY) ) FROM EMPLOYEE; 

-- 부서 코드가 'D9'인 사원들의 급여 합, 평균
SELECT SUM(SALARY) "급여 합", ROUND(AVG(SALARY)) 평균
FROM EMPLOYEE
WHERE DEPT_CODE IN('D9');

-- MIN(컬럼명) : 최소값
-- MAX(컬럼명) : 최대값
--> 타입 제한 없음 ( 숫자 : 대/소, 날짜: 과거/미래, 문자열 : 문자 순서 )

-- 급여 최소값, 가장 빠른 입사일, 알파벳 순서가 가장 빠른 이메일
SELECT MIN(SALARY), MIN(HIRE_DATE), MIN(EMAIL)  
FROM EMPLOYEE;

-- 급여 최대값, 가장 최신 입사일, 알파벳 순서가 가장 느린 이메일
SELECT MAX(SALARY), MAX(HIRE_DATE), MAX(EMAIL)  
FROM EMPLOYEE;


-- EMPLOYEE 테이블에서 급여를 가장 많이 받는 사원의
-- 이름, 급여, 직급코드 조회
SELECT EMP_NAME, SALARY, JOB_CODE
FROM EMPLOYEE
WHERE SALARY = ( SELECT MAX(SALARY) FROM EMPLOYEE ); -- 서브 쿼리 + 그룹 함수


-- * COUNT(* | 컬럼명) : 행 개수를 헤아려서 리턴
-- COUNT(DISTINCT 컬럼명) : 중복을 제거한 행 개수를 헤아려 리턴
-- COUNT(*) : NULL을 포함한 전체 행 개수 리턴
-- COUNT(컬럼명) : NULL을 제외한 실제 값이 기록된 행 개수를 리턴

-- EMPLOYEE 테이블의 행의 갯수
SELECT COUNT(*) FROM EMPLOYEE;

-- BONUS를 받는 사원 수
SELECT COUNT(BONUS) FROM EMPLOYEE;

SELECT COUNT(*)
FROM EMPLOYEE
WHERE BONUS IN NOT NULL; -- 좋은 방법은 아닌데, 여러 가지 작성 가능하다는 것 보여줌


-- EMPLOYEE 테이블에서 성별이 남성인 사원의 수 조회
SELECT COUNT(*) 
FROM EMPLOYEE
WHERE SUBSTR(EMP_NO, 8, 1) = '1'; 


-- UPPER 함수의 역할
SELECT EMO_NO, UPPER(EMP_NAME)
FROM EMPLOYEE;

-- 조회한 컬럼이 영문자일 경우 대문자로 바꿔주는 함수