package com.ssafy.dimong_be.infrastructure.http;

import org.springframework.core.io.Resource;
import org.springframework.http.HttpEntity;
import org.springframework.http.MediaType;
import org.springframework.http.client.MultipartBodyBuilder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.util.MultiValueMap;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.reactive.function.client.WebClient;
import org.springframework.web.reactive.function.client.WebClientResponseException;

import com.ssafy.dimong_be.application.AIService;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;
import reactor.core.publisher.Mono;

@Service
@Transactional
@RequiredArgsConstructor
@Slf4j
public class HttpAIService implements AIService {

	private final WebClient webClient;

	public DinosaurNameDto getRecommendedDinosaurName(MultipartFile file) {
		MultipartBodyBuilder builder = new MultipartBodyBuilder();

		// Add file part
		Resource image = file.getResource();
		builder.part("image", image);

		// Build and use
		MultiValueMap<String, HttpEntity<?>> multipartBody = builder.build();

		return webClient.post()
			.uri("/ai/v1/pictures/dinosaurs")
			.accept(MediaType.APPLICATION_JSON)
			.contentType(MediaType.MULTIPART_FORM_DATA)
			.bodyValue(multipartBody)
			.retrieve()
			.bodyToMono(DinosaurNameDto.class)
			.onErrorResume(WebClientResponseException.class,
				ex -> ex.getStatusCode().value() == 404 ? Mono.empty() : Mono.error(ex))
			.block();
	}

	public DinosaurNameListDto getRecommendedDinosaurNameList(MultipartFile file) {
		MultipartBodyBuilder builder = new MultipartBodyBuilder();

		// Add file part
		Resource image = file.getResource();
		builder.part("image", image);

		// Build and use
		MultiValueMap<String, HttpEntity<?>> multipartBody = builder.build();

		return webClient.post()
			.uri("/ai/v1/drawings/dinosaurs")
			.accept(MediaType.APPLICATION_JSON)
			.contentType(MediaType.MULTIPART_FORM_DATA)
			.bodyValue(multipartBody)
			.retrieve()
			.bodyToMono(DinosaurNameListDto.class)
			.onErrorResume(WebClientResponseException.class,
				ex -> ex.getStatusCode().value() == 404 ? Mono.empty() : Mono.error(ex))
			.block();
	}

}
