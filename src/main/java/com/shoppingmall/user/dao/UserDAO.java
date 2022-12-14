package com.shoppingmall.user.dao;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Repository;

import com.shoppingmall.user.model.User;

@Repository
public interface UserDAO {
	
	// 아이디 중복 리스트
	public List<String> existLoginId(String loginId);
	
	// 전화번호 중복 리스트
	public List<String> existPhoneNumber(String phoneNumber);
	
	// 회원 가입
	public int insertUser(
			@Param("loginId")String loginId,
			@Param("password")String  password,
			@Param("name")String  name,
			@Param("address")String address,
			@Param("phoneNumber")String phoneNumber);
	
	// 로그인
	public User selectUserByLoginIdAndPassword(
			@Param("loginId")String loginId,
			@Param("password")String  password);
	
	// loginId로 Id 찾기
	public Integer selectIdByLoginId(String loginId);
	
	// id 로 유저 가져오기
	public User selectUserByUserId(int id);
	
	
	// 회원정보 수정
	public int updateUser(
			@Param("id") int  id,
			@Param("password") String  password,
			@Param("name") String  name,
			@Param("address") String address,
			@Param("phoneNumber") String phoneNumber);

	public int updateUserType(
			@Param("id") int  id,
			@Param("type") int  type);
	
}
