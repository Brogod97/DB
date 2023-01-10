/* SELECT문 해석 순서
 * 
 * 5. SELECT 컬럼명 AS 별칭, 계산식, 함수식
 * 1. FROM 참조할 테이블명
 * 2. WEHRE 컬러명 | 함수식 비교 연산자 비교값
 * 3. GROUP BY 그룹을 묶을 컬럼명
 * 4. HAVING 그룹함수식 비교 연산자 비교값
 * 6. ORDER BY 컬럼명 | 별칭 | 컬럼순번 정렬방식 [ NULLS FIRST | LAST ]
 * 
 * */


-- GROUP BY 절 : 같은 값들이 여러개 기록된 컬럼을 가지고 같은 값들을 하나의 그룹으로 묶음
-- GROUP BY 컬럼명 | 함수식, ..
-- 여러개의 값을 묶어서 하나로 처리할 목적으로 사용함.
-- 그룹으로 묶은 값에 대해서 SELECT절에서 그룹함수를 사용함.


-- EMPLOYEE 테이블에서 부서코드, 부서별 급여 합 조회

-- 1) 부서 코드만 조회
SELECT DEPT_CODE  FROM EMPLOYEE; -- 23행

-- 2) 전체 급여 합 조회
SELECT SUM(SALARY) FROM EMPLOYEE; -- 1행

SELECT DEPT_CODE, SUM(SALARY)
FROM EMPLOYEE
GROUP BY DEPT_CODE; --> DEPT_CODE가 같은 행 끼리 하나의 그룹이 됨

-- EMPLOYEE 테이블에서
-- 직급코드가 같은 사람의 직급코드, 급여 평균, 인원수를
-- 직급코드 오름차순으로 조회
SELECT JOB_CODE, ROUND(AVG(SALARY)) "급여 평균", COUNT(*) 인원수
FROM EMPLOYEE
GROUP BY JOB_CODE 
ORDER BY JOB_CODE;

SELECT JOB_CODE FROM EMPLOYEE;


-- EMPLOYEE 테이블에서
-- 성별(남/여)과 각 성별 별 인원 수, 급여 합을
-- 인원수 오름차순으로 조회
SELECT DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') 성별, 
	   COUNT(*) "인원 수",
	   SUM(SALARY) "급여 합"
FROM EMPLOYEE
GROUP BY DECODE(SUBSTR(EMP_NO, 8, 1), '1', '남', '2', '여') -- 별칭 사용이 X (SELECT절 해석 전)
ORDER BY "인원 수"; -- 별칭 사용 O (SELECT절 해석 완료)

---------------------------------------------------------------------------
-- EMPLOYEE 테이블에서 부서코드가 D5, D6인 부서의 평균 급여, 인원 수 조회

SELECT DEPT_CODE, ROUND(AVG(SALARY))  "평균 급여", COUNT(*) "인원 수"  
FROM EMPLOYEE
WHERE DEPT_CODE IN('D5', 'D6')
GROUP BY DEPT_CODE;

-- EMPLOYEE 테이블에서 직급별 2000년도 이후 (2000년 포함) 입사자들의 직급코드, 급여 합을 조회
-- 직급코드 오름차순

SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE HIRE_DATE >= '2000-01-01'
GROUP BY JOB_CODE 
ORDER BY JOB_CODE;

-- 방법 1 : 형 변환이 없어서 가장 빠르다.
SELECT JOB_CODE, SUM(SALARY)
FROM EMPLOYEE
WHERE EXTRACT(YEAR FROM HIRE_DATE >= 2000)
-- 방법 2 : HIRE_DATE >= TO_DATE('2000-01-01')
-- 방법 3 : TO NUMBER(SUBSTR(TO_CHAR(HIRE_DATE), 1, 4)) >= 2000
GROUP BY JOB_CODE;
ORDER BY 1;


-- EMPLOYEE 테이블에서 부서별로 같은 직급인 사원의 수를 조회
-- 부서코드는 오름차순, 직급코드 내림차순

SELECT DEPT_CODE, JOB_CODE, COUNT(*)
FROM EMPLOYEE
GROUP BY DEPT_CODE, JOB_CODE -- DEPT_CODE로 그룹을 나누고, 
							 -- 나눠진 그룹 내에서 JOB_CODE 또 그룹 분류
							 --> 세분화
ORDER BY DEPT_CODE, JOB_CODE DESC;


-- GROUP BY 사용시 주의사항
--> SELECT문에 GROUP BY절을 사용할 경우
-- SELECT절에 명시한 조회하려는 컬럼 중
-- 그룹 함수가 적용되지 않은 컬럼을
-- 모두 GROUP BY 절에 작성해야 함


---------------------------------------------------------------------------

-- 부서별 평균 급여가 3백만원 이상인 부서를 조회(부서코드 오름차순)
SELECT DEPT_CODE, FLOOR(AVG(SALARY)) 
FROM EMPLOYEE
-- WHERE SALARY >= 3000000 --> 한 사람의 급여가 300만 이상이라는 조건
GROUP BY DEPT_CODE
HAVING AVG(SALARY) >= 3000000 --> DEPT_CODE 그룹 중 급여 평균이 300만 이상인 그룹만 남음
ORDER BY DEPT_CODE;


-- EMPLOYEE 테이블에서 직급별 인원수가 5명 이하인 직급코드, 인원 수 조회(직급코드 오름차순)
SELECT JOB_CODE, COUNT(*) 
FROM EMPLOYEE
GROUP BY JOB_CODE 
HAVING COUNT(*) <= 5 --> HAVING절에는 그룹함수가 반드시 작성된다!!!
ORDER BY JOB_CODE;